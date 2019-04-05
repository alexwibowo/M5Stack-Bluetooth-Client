//
//  BLEManager.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 16/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager?
    
    private(set) var connectedPeripheral: CBPeripheral?
    
    private(set) var connectionState: ConnectionState = .disconnected {
        didSet {
            delegate?.didUpdateConnectionState?(connectionState)
        }
    }
    
    private var searchState: SearchState = .idle
    private(set) var services: [CBService]?
    weak var delegate: BLEDelegate?
    
    private var timeoutMonitor : Timer?
    
    private(set) lazy var state: CBManagerState? = {
        guard centralManager != nil else {
            return nil
        }
        return CBManagerState(rawValue: (centralManager?.state.rawValue)!)
    }()
    
    static let shared = BLEManager()
    
    private override init() {
        super.init()
        internalInit()
    }
    
    private func internalInit() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.appDidResume),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.appDidBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    func startScan() {
        if searchState == .searching || centralManager?.state != CBManagerState.poweredOn{
            return
        }
        searchState = .searching
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.stopScan), userInfo: nil, repeats: false)
    }
    
    @objc func stopScan() {
        searchState = .idle
        centralManager?.stopScan()
        delegate?.didFinishDiscoverPeripheral?()
    }
    
    func connect(_ peripheral: CBPeripheral, options: [String : Any]?) {
        if connectionState != .connecting {
            connectionState = .connecting
            centralManager?.connect(peripheral, options: options)
            timeoutMonitor = Timer.scheduledTimer(timeInterval: 3.0,
                                                  target: self,
                                                  selector: #selector(self.connectTimeout(_:)),
                                                  userInfo: peripheral,
                                                  repeats: false)
        }
    }
    
    func disconnect(_ peripheral: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(peripheral)
        delegate?.didDisconnectPeripheral?(peripheral)
    }
    
    func disconnectCurrentPeripheral() {
        if let peripheral = connectedPeripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
            delegate?.didDisconnectPeripheral?(peripheral)
        }
    }
    
    @objc func connectTimeout(_ timer : Timer) {
        if connectionState == .connecting {
            connectionState = .disconnected
            self.disconnectCurrentPeripheral()
            timeoutMonitor = nil
            delegate?.bleErrorHandler?(.timeOut)
        }
    }
    
    func discoverCharacteristics() {
        if connectedPeripheral == nil {
            return
        }
        let services = connectedPeripheral!.services
        if services == nil || services!.count < 1 { // Validate service array
            return;
        }
        for service in services! {
            connectedPeripheral!.discoverCharacteristics(nil, for: service)
        }
    }
    
    // MARK: Manager Delegates
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            if connectionState == .disconnected {
                startScan()
            }
        case .poweredOff:
            delegate?.bleErrorHandler?(.poweredOff)
        case .resetting:
            delegate?.bleErrorHandler?(.poweredOff)
        case .unauthorized:
            delegate?.bleErrorHandler?(.poweredOff)
        case .unknown:
            delegate?.bleErrorHandler?(.poweredOff)
        case .unsupported:
            delegate?.bleErrorHandler?(.poweredOff)
        }
        
        if let state = self.state {
            delegate?.didUpdateState?(state)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard RSSI.intValue != 127 else {
            return
        }
        
        if CBUUID(nsuuid: peripheral.identifier) == CBUUID(string: "A28C88F8-B4B3-C499-AFB6-216AABCDC15B") {
            print(advertisementData)
        }
        let distance = calculateDistance(rssi: RSSI.intValue, txPower: 1)
        delegate?.didDiscoverPeripheral?(peripheral, advertisementData: advertisementData, RSSI: RSSI.intValue)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager?.stopScan()
        peripheral.delegate = self
        connectedPeripheral = peripheral
        peripheral.discoverServices(nil)
        connectionState = .connected
        delegate?.didConnectPeripheral?(peripheral)
        NotificationCenter.default.post(name: Notification.Name.PeripheralConnected, object: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectionState = .disconnected
        delegate?.didDisconnectPeripheral?(peripheral)
        NotificationCenter.default.post(name: Notification.Name.PeripheralDisconnected, object: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.bleErrorHandler?(.unknown)
    }
    
    // MARK: Peropheral Delegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if error != nil {
            delegate?.bleErrorHandler?(.unknown)
            return
        }
        
        connectedPeripheral = peripheral
        services = peripheral.services
        self.discoverCharacteristics()
        for service in services! {
            connectedPeripheral!.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        if error != nil {
            delegate?.didFailToDiscoverCharacteritics?(error!)
            return
        }
        delegate?.didDiscoverCharacteritics?(service)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            delegate?.didFailToDiscoverDescriptors?(error!)
            return
        }
        delegate?.didDiscoverDescriptors?(characteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        delegate?.deviceDistance?(peripheral, distance: calculateDistance(rssi: RSSI.intValue, txPower: 1))
    }
    
    func calculateDistance(rssi:Int,txPower:Int) -> Double {
        /*
         * RSSI = TxPower - 10 * n * lg(d)
         * n = 2 (in free space)
         *
         * d = 10 ^ ((TxPower - RSSI) / (10 * n))
         */
        let result = pow(10.0, (txPower - rssi) / (10 * 4))
        return NSDecimalNumber(decimal: result).doubleValue/10.0
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.didReadValueForCharacteristic?(characteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.didWriteValueForCharacteristic?(characteristic)
    }
    
    func write(_ data: Data, for characteristic: CBCharacteristic ) {
        connectedPeripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }
}

extension BLEManager {
    
    @objc func appDidResume() {
        print(#function)
    }
    
    @objc func appDidBackground() {
        print(#function)
    }
    
    struct Events {
        static func registerConnection(target: Any, selector: Selector) {
            NotificationCenter.default.addObserver(
                target,
                selector: selector,
                name: NSNotification.Name.PeripheralConnected,
                object: nil
            )
        }
        
        static func registerDisconnection(target: Any, selector: Selector) {
            NotificationCenter.default.addObserver(
                target,
                selector: selector,
                name: NSNotification.Name.PeripheralDisconnected,
                object: nil
            )
        }
    }
    
    class func NotifyDisconnection() {
        
    }
}


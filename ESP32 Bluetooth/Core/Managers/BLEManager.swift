//
//  BLEManager.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 16/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

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
        centralManager = CBCentralManager(delegate: self, queue: nil)
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
    
    @objc func connectTimeout(_ timer : Timer) {
        if connectionState == .connecting {
            connectionState = .disconnected
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
            delegate?.bleErrorHandler(.poweredOff)
        case .resetting:
            delegate?.bleErrorHandler(.poweredOff)
        case .unauthorized:
            delegate?.bleErrorHandler(.poweredOff)
        case .unknown:
            delegate?.bleErrorHandler(.poweredOff)
        case .unsupported:
            delegate?.bleErrorHandler(.poweredOff)
        }
        
        if let state = self.state {
            delegate?.didUpdateState(state)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard RSSI.intValue != 127 else {
            return
        }
        delegate?.didDiscoverPeripheral(peripheral, advertisementData: advertisementData, RSSI: RSSI.intValue)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager?.stopScan()
        peripheral.delegate = self
        connectedPeripheral = peripheral
        connectionState = .connected
        delegate?.didConnectPeripheral(peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectionState = .disconnected
        delegate?.didDisconnectPeripheral?(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.bleErrorHandler(.unknown)
    }

    
    // MARK: Peropheral Delegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        connectedPeripheral = peripheral
        
        if error != nil {
            print("Bluetooth Manager --> Discover Services Error, error:\(error?.localizedDescription ?? "")")
            return ;
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Bluetooth Manager --> didDiscoverCharacteristicsForService")
        if error != nil {
            print("Bluetooth Manager --> Fail to discover characteristics! Error: \(error?.localizedDescription ?? "")")
            delegate?.didFailToDiscoverCharacteritics?(error!)
            return
        }
        delegate?.didDiscoverCharacteritics?(service)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("Bluetooth Manager --> didDiscoverDescriptorsForCharacteristic")
        if error != nil {
            print("Bluetooth Manager --> Fail to discover descriptor for characteristic Error:\(error?.localizedDescription ?? "")")
            delegate?.didFailToDiscoverDescriptors?(error!)
            return
        }
        delegate?.didDiscoverDescriptors?(characteristic)
    }
    
}

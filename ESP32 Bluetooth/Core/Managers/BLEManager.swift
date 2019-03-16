//
//  BLEManager.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 16/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private static let shared = BLEManager()
    var manager: CBCentralManager?
    private var devices: [Device] = []
    private(set) var connectionState: ConnectionState = .disconnected
    weak var delegate: BLEServiceDelegate?
    private var timeoutMonitor : Timer?
    private(set) lazy var state: CBManagerState? = {
        guard manager != nil else {
            return nil
        }
        return CBManagerState(rawValue: (manager?.state.rawValue)!)
    }()
    
    private override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        manager?.scanForPeripherals(withServices: nil, options: nil)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.stopScan), userInfo: nil, repeats: false)
    }
    
    @objc func stopScan() {
        manager?.stopScan()
        delegate?.didDiscoverDevices(devices)
    }
    
    func connect(_ peripheral: CBPeripheral, options: [String : Any]?) {
        if connectionState != .connecting {
            connectionState = .connecting
            manager?.connect(peripheral, options: options)
            timeoutMonitor = Timer.scheduledTimer(timeInterval: 3.0,
                                                  target: self,
                                                  selector: #selector(self.connectTimeout(_:)),
                                                  userInfo: peripheral,
                                                  repeats: false)
        }
    }
    
    func disconnect(_ peripheral: CBPeripheral) {
        manager?.cancelPeripheralConnection(peripheral)
        delegate?.didDisconnectPeripheral(peripheral)
    }
    
    @objc func connectTimeout(_ timer : Timer) {
        if connectionState == .connecting {
            connectionState = .disconnected
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScan()
        case .poweredOff:
            delegate?.handleErrors(.poweredOff(message: "Turn on Bluetooth in Settings to enable connection."))
        case .resetting:
            delegate?.handleErrors(.resetting(message: "Bluetooth is resetting on this device."))
        case .unauthorized:
            delegate?.handleErrors(.unauthorized(message: "Bluetooth is unauthorized on this device."))
        case .unknown:
            delegate?.handleErrors(.unknown(message: "Bluetooth is unknown on this device."))
        case .unsupported:
            delegate?.handleErrors(.unsupported(message: "Bluetooth is unsupported on this device."))
        }
        
        if let state = self.state {
            delegate?.didUpdateState(state)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard RSSI.intValue != 127 else {
            return
        }
        let peripheralData = Device(peripheral: peripheral, RSSI: RSSI.intValue, advertisementData: advertisementData)
        if(!devices.contains(peripheralData)) {
            devices.append(peripheralData)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        manager?.stopScan()
        delegate?.didConnectPeripheral(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.handleErrors(.unknown(message: "Can't connect to device"))
    }
}

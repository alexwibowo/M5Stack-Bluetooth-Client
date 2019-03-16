//
//  BLEService.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 08/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BLEServiceErrors: Error {
    case poweredOff(message: String)
    case resetting(message: String)
    case unauthorized(message: String)
    case unknown(message: String)
    case unsupported(message: String)
    case noDevices(message: String)
}

protocol BLEServiceDelegate: NSObjectProtocol {
    func handleErrors(_ error: BLEServiceErrors)
    func didConnectPeripheral(_ connectedPeripheral: CBPeripheral)
    func didUpdateState(_ state: CBManagerState)
    func didDiscoverDevices(_ devices: [Device])
    func didDisconnectPeripheral(_ peripheral: CBPeripheral)
}

protocol BLEServiceProtocol: class {
    
    var manager: CBCentralManager? {get set}
    var devices: [Device] {get set}
    var state: CBManagerState? {get set}
    var peripheralServices: [CBUUID]? {get set}
    var peripheralOptions: [String: Any]? {get set}
    var delegate: BLEServiceDelegate? {get}
    
    init(peripheralServices: [CBUUID]?, peripheralOptions: [String: Any]?, autostart: Bool?)
    func startScan()
    func startScan(services: [CBUUID]?, options: [String: Any]?)
    func stopScan()
    func connect(_ peripheral: CBPeripheral, options: [String : Any]?)
    func disconnect(_ peripheral: CBPeripheral)
    
}

class BLEService: NSObject, BLEServiceProtocol {
    
    internal var manager: CBCentralManager?
    internal var devices: [Device] = []
    internal var peripheralServices: [CBUUID]?
    internal var peripheralOptions: [String: Any]?
    weak var delegate: BLEServiceDelegate?
    var autostart: Bool = true
    internal lazy var state: CBManagerState? = {
        guard manager != nil else {
            return nil
        }
        return CBManagerState(rawValue: (manager?.state.rawValue)!)
    }()
    
    required init(peripheralServices: [CBUUID]?, peripheralOptions: [String: Any]?, autostart: Bool?) {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
        self.peripheralServices = peripheralServices
        self.peripheralOptions = peripheralOptions
        self.autostart = autostart ?? false
    }
    
    init(autostart: Bool?) {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        self.autostart = autostart ?? false
    }
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        self.startScan(services: nil, options: nil)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.stopScan), userInfo: nil, repeats: false)
    }
    
    func startScan(services: [CBUUID]?, options: [String: Any]?) {
        manager?.scanForPeripherals(withServices: services, options: options)
    }
    
    @objc func stopScan() {
        manager?.stopScan()
        delegate?.didDiscoverDevices(devices)
    }
    
    func connect(_ peripheral: CBPeripheral, options: [String : Any]?) {
        manager?.connect(peripheral, options: options)
    }
    
    func disconnect(_ peripheral: CBPeripheral) {
        manager?.cancelPeripheralConnection(peripheral)
        delegate?.didDisconnectPeripheral(peripheral)
    }
}

extension BLEService: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            if autostart {
                startScan(services: peripheralServices, options: peripheralOptions)
            }
            let _ = (autostart == true) ? "autostart activado" : "autostart desactivado"
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

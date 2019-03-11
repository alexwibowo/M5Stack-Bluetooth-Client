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
}

protocol BLEServiceDelegate: class {
    func handleErrors(_ error: BLEServiceErrors)
}

protocol BLEServiceProtocol: class {
    
    var peripherals: [CBPeripheral] {get set}
    var manager: CBCentralManager! {get set}
    var peripheralServices: [CBUUID]? {get set}
    var peripheralOptions: [String: Any]? {get set}
    var delegate: BLEServiceDelegate? {get}
    var devicesFound: (([CBPeripheral]) -> Void)? {get}
    var deviceConnected: ((CBPeripheral) -> Void)? {get}
    
    init(services: [CBUUID]?, options: [String: Any]?)
    func scanForDevices(services: [CBUUID]?, options: [String: Any]?)
    func stopScan()
    func connect(peripheral: CBPeripheral, options: [String : Any]?, completion: (_ status: Bool) -> Void)
    func disconnect(peripheral: CBPeripheral)
}

class BLEService: NSObject, BLEServiceProtocol {
    
    internal var peripherals: [CBPeripheral] = []
    internal var manager: CBCentralManager!
    internal var peripheralServices: [CBUUID]?
    internal var peripheralOptions: [String: Any]?
    
    var devicesFound: (([CBPeripheral]) -> Void)?
    var deviceConnected: ((CBPeripheral) -> Void)?
    weak var delegate: BLEServiceDelegate?
    
    required init(services: [CBUUID]?, options: [String: Any]?) {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
        self.peripheralServices = services
        self.peripheralOptions = options
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.stopScan), userInfo: nil, repeats: false)
    }
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.stopScan), userInfo: nil, repeats: false)
    }
    
    internal func scanForDevices(services: [CBUUID]?, options: [String: Any]?) {
        manager.scanForPeripherals(withServices: services, options: options)
    }
    
    @objc internal func stopScan() {
        devicesFound?(peripherals)
        manager.stopScan()
    }
    
    func connect(peripheral: CBPeripheral, options: [String : Any]?, completion: (_ status: Bool) -> Void) {
        manager.connect(peripheral, options: options)
        completion(true)
    }
    
    func disconnect(peripheral: CBPeripheral) {
        //
    }
}

extension BLEService: CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            scanForDevices(services: peripheralServices, options: peripheralOptions)
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
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if(!peripherals.contains(peripheral)) {
            peripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        deviceConnected?(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.handleErrors(.unknown(message: "Can't connect to device"))
    }
}

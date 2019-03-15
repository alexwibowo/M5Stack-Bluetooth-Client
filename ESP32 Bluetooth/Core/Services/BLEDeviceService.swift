//
//  PeripheralService.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 10/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEDeviceService: NSObject, CBPeripheralDelegate {
    
    var device: CBPeripheral!
    var BLECharacteristic: [String] = []
    var mainCharacteristics: [CBCharacteristic]?
    var didUpdateValue: ((CBCharacteristic) -> Void)?
    
    init(_ device: CBPeripheral) {
        super.init()
        self.device = device
        self.device.delegate = self
    }
    
    func name() -> String {
        return device.name ?? ""
    }
    
    func isConnected() -> Bool {
        return device.state == .connected ? true : false
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        mainCharacteristics = characteristics
        for characteric in characteristics {
            if characteric.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteric)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if(characteristic.value != nil) {
            self.didUpdateValue?(characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("write error")
        }
    }
    
    func writeData(characteristic: CBCharacteristic, data: Data) {
        self.device.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func readData(characteristic: CBCharacteristic) {
        self.device.readValue(for: characteristic)
    }
}

//
//  PeripheralService.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 10/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import Foundation
import CoreBluetooth

class PeripheralService: NSObject, CBPeripheralDelegate {
    
    weak var delegate: HeartRatePeripheralDelegate?
    var peripheral: CBPeripheral!
    var BLECharacteristic: [String] = []
    var mainCharacteristics: [CBCharacteristic]?
    var didUpdateValue: ((CBCharacteristic) -> Void)?
    
    init(_ peripheral: CBPeripheral) {
        super.init()
        self.peripheral = peripheral
        self.peripheral.delegate = self
    }
    
    func name() -> String {
        return peripheral.name ?? "Zibra device"
    }
    
    func isConnected() -> Bool {
        return peripheral.state == .connected ? true : false
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
            //let stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
            //print(stringValue)
        }
            
        //        if characteristic.uuid == Library.heartRateMeasurementCharacteristic {
        //            guard let value = characteristic.value else { return }
        //            let byteArray = [UInt8](value)
        //            let heartRate = (Int(byteArray[0] & 0x01) == 0) ? Int(byteArray[1]) : (256 * Int(byteArray[1])) + Int(byteArray[2])
        //            delegate?.didUpdateHeartRate(heartRate)
        //        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("write error")
        }
    }
    
    func writeData(characteristic: CBCharacteristic, data: Data) {
        self.peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func readData(characteristic: CBCharacteristic) {
        self.peripheral.readValue(for: characteristic)
    }
}


//class PeripheralService: NSObject, CBPeripheralDelegate {
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if (characteristic.uuid.uuidString == "2A00") {
//            //value for device name recieved
//            let deviceName = characteristic.value
//            print(deviceName ?? "No Device Name")
//        } else if (characteristic.uuid.uuidString == "2A29") {
//            //value for manufacturer name recieved
//            let manufacturerName = characteristic.value
//            print(manufacturerName ?? "No Manufacturer Name")
//        } else if (characteristic.uuid.uuidString == "2A23") {
//            //value for system ID recieved
//            let systemID = characteristic.value
//            print(systemID ?? "No System ID")
//        } else if (characteristic.uuid.uuidString == BLECharacteristic) {
//            //data recieved
//            if(characteristic.value != nil) {
//                let stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
//                print(stringValue)
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        for service in peripheral.services! {
//
//            print("Service found with UUID: " + service.uuid.uuidString)
//
//            //device information service
//            if (service.uuid.uuidString == "180A") {
//                peripheral.discoverCharacteristics(nil, for: service)
//            }
//
//            //GAP (Generic Access Profile) for Device Name
//            // This replaces the deprecated CBUUIDGenericAccessProfileString
//            if (service.uuid.uuidString == "1800") {
//                peripheral.discoverCharacteristics(nil, for: service)
//            }
//
//            //Bluno Service
//            if (service.uuid.uuidString == BLEService) {
//                peripheral.discoverCharacteristics(nil, for: service)
//            }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        if (service.uuid.uuidString == BLEService) {
//
//            for characteristic in service.characteristics! {
//
//                if (characteristic.uuid.uuidString == BLECharacteristic) {
//                    //we'll save the reference, we need it to write data
//                    mainCharacteristic = characteristic
//
//                    //Set Notify is useful to read incoming data async
//                    peripheral.setNotifyValue(true, for: characteristic)
//                    print("Found Bluno Data Characteristic")
//                }
//
//            }
//
//        }
//
//    }
//}

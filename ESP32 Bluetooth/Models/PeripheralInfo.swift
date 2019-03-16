//
//  PeripheralInfo.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 15/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import CoreBluetooth

struct Device: Equatable, Hashable {
    
    let peripheral: CBPeripheral
    let RSSI: Int
    let advertisementData: [String : Any]
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.peripheral.isEqual(rhs.peripheral)
    }
    
    var hashValue: Int {
        return peripheral.hash
    }
}

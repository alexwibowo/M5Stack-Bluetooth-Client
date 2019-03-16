//
//  PeripheralInfo.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 15/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import CoreBluetooth

struct Device: Equatable, Hashable {
    
    var peripheral: CBPeripheral
    var advertisementData: [String : Any] = [:]
    var rssi: Int = 0
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.peripheral.isEqual(rhs.peripheral)
    }
    
    var hashValue: Int {
        return peripheral.hash
    }
}

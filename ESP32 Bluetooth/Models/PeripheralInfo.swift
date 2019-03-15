//
//  PeripheralInfo.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 15/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import CoreBluetooth

struct PeripheralData: Equatable, Hashable {
    
    let peripheral: CBPeripheral
    let RSSI: NSNumber
    let advertisementData: [String : Any]
    
    static func == (lhs: PeripheralData, rhs: PeripheralData) -> Bool {
        return lhs.peripheral.isEqual(rhs.peripheral)
    }
    
    var hashValue: Int {
        return peripheral.hash
    }
}

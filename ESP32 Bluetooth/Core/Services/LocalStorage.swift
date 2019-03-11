//
//  LocalStorage.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 11/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import Foundation

class LocalStorage {
    
    func getDevices() -> String? {
        return UserDefaults.standard.string(forKey: "device")
    }
    
    func storeDevice(uuid: String) {
        UserDefaults.standard.set(uuid, forKey: "device")
    }
    
}

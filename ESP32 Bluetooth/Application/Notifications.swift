//
//  Notifications.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 16/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let PeripheralConnected = NSNotification.Name("PeripheralConnected")
    static let PeripheralDisconnected = NSNotification.Name("PeripheralDisconnected")
}

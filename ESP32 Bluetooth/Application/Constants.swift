//
//  Constants.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 08/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import Foundation

enum DiscoveryState {
    case StandBy
    case Searching
}

enum ConnectionState {
    case connecting
    case connected
    case disconnected
}

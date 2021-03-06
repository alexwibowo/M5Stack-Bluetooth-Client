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

@objc public enum ConnectionState: Int {
    case connecting
    case connected
    case disconnected
}

@objc public enum SearchState: Int {
    case searching
    case idle
}

public enum DeviceEvents {
    case connected
    case disconnected
}

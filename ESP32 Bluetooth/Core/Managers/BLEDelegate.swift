//
//  BLEDelegate.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 16/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import CoreBluetooth

@objc public enum BLEServiceErrors: Int {
    case poweredOff
    case resetting
    case unauthorized
    case unknown
    case unsupported
    case noDevices
    case timeOut
}

@objc protocol BLEDelegate: NSObjectProtocol {
    
    // Bluetooth manager delegates
    @objc optional func didUpdateState(_ state: CBManagerState)
    @objc optional func didConnectPeripheral(_ connectedPeripheral: CBPeripheral)
    @objc optional func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: Int)
    @objc optional func didFinishDiscoverPeripheral()
    @objc optional func didDisconnectPeripheral(_ peripheral: CBPeripheral)
    
    // Peripheral related delegates
    @objc optional func didDiscoverCharacteritics(_ service: CBService)
    @objc optional func didFailToDiscoverCharacteritics(_ error: Error)
    
    @objc optional func didDiscoverDescriptors(_ characteristic: CBCharacteristic)
    @objc optional func didFailToDiscoverDescriptors(_ error: Error)
    
    @objc optional func didReadValueForCharacteristic(_ characteristic: CBCharacteristic)
    @objc optional func didWriteValueForCharacteristic(_ characteristic: CBCharacteristic)
    @objc optional func didFailToReadValueForCharacteristic(_ error: Error)
    
    // aditional methods
    @objc optional func deviceDistance(_ peripheral: CBPeripheral, distance: Double)
    // app connection state delegates
    @objc optional func didUpdateConnectionState(_ state: ConnectionState)
    
    // error handling related delegates
    @objc optional func bleErrorHandler(_ error: BLEServiceErrors)
}

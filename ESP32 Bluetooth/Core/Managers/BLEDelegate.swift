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
}

@objc protocol BLEDelegate: NSObjectProtocol {
    
    // Bluetooth manager delegates
    @objc func didUpdateState(_ state: CBManagerState)
    @objc func didConnectPeripheral(_ connectedPeripheral: CBPeripheral)
    @objc func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: Int)
    @objc optional func didFinishDiscoverPeripheral()
    @objc optional func didDisconnectPeripheral(_ peripheral: CBPeripheral)
    
    // Peripheral related delegates
    @objc optional func didDiscoverCharacteritics(_ service: CBService)
    @objc optional func didFailToDiscoverCharacteritics(_ error: Error)
    
    @objc optional func didDiscoverDescriptors(_ characteristic: CBCharacteristic)
    @objc optional func didFailToDiscoverDescriptors(_ error: Error)
    
    @objc optional func didReadValueForCharacteristic(_ characteristic: CBCharacteristic)
    @objc optional func didFailToReadValueForCharacteristic(_ error: Error)
    
    // app connection state delegates
    @objc optional func didUpdateConnectionState(_ state: ConnectionState)
    
    // error handling related delegates
    @objc func bleErrorHandler(_ error: BLEServiceErrors)
}

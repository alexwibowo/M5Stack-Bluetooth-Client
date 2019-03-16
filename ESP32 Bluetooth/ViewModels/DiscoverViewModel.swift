//
//  DiscoverViewModel.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 08/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import CoreBluetooth
import SwiftDate

class DiscoverViewModel: NSObject {

    private let bleService = BLEService(autostart: true)
    var devices: [Device] = []
    fileprivate var discoveryState: DiscoveryState = .StandBy
    
    var didDiscoverDevices: ((_ devices: [Device]) -> Void)?
    var connectedDevice: ((_ connectedDevice: Device) -> Void)?
    var errorHandler: ((_ error: BLEServiceErrors) -> Void)?
    override init() {
        super.init()
        bleService.delegate = self
    }
    
    func connect(peripheral: CBPeripheral) {
        bleService.connect(peripheral, options: nil)
    }
    
    func unload() {
        bleService.stopScan()
//        bleService.manager = nil
    }
}

extension DiscoverViewModel: BLEServiceDelegate {
    
    internal func didUpdateState(_ state: CBManagerState) {
        if state == .poweredOn {
            bleService.startScan()
            discoveryState = .Searching
        }
    }
    
    func didDiscoverDevices(_ devices: [Device]) {
        didDiscoverDevices?(devices)
    }
    
    internal func didConnectPeripheral(_ connectedPeripheral: CBPeripheral) {
        discoveryState = .StandBy
        let peripheralData = devices.first { (peripheralData) -> Bool in
            if peripheralData.peripheral == connectedPeripheral {
                return true
            }
            return false
        }
        guard let peripheral = peripheralData else {return}
        
        self.connectedDevice?(peripheral)
    }
    
    internal func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
        // do nothing
    }
    
    internal func handleErrors(_ error: BLEServiceErrors) {
        errorHandler?(error)
    }
}

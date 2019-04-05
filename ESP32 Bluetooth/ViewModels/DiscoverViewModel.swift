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
    
    let services: [CBUUID] = [CBUUID(string: DeviceNames.TemperatureServiceUUID)]
    
    private var bleManager = BLEManager.shared
    var devices: [Device] = []
    var didDiscoverDevices: ((_ devices: [Device]) -> Void)?
    var connectedDevice: ((_ connectedDevice: Device) -> Void)?
    var errorHandler: ((_ error: BLEServiceErrors) -> Void)?
    
    var refreshTimer: Timer!
    
    override init() {
        super.init()
        bleManager.delegate = self
        bleManager.startScan()
    }
    
    func connect(peripheral: CBPeripheral) {
        bleManager.connect(peripheral, options: nil)
    }
    
    @objc private func refreshDeviceList() {
        devices.removeAll()
        bleManager.startScan()
    }
    
    func unload() {
        refreshTimer.invalidate()
    }
}

extension DiscoverViewModel: BLEDelegate {
    
    internal func didUpdateState(_ state: CBManagerState) {
        if state == .poweredOn {
            bleManager.startScan()
        }
    }
    
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: Int) {
        let device = Device(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
        if !devices.contains(device) {
            devices.append(device)
        }
    }
    
    func didFinishDiscoverPeripheral() {
        self.didDiscoverDevices?(devices)
        refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshDeviceList), userInfo: nil, repeats: false)
    }
    
    internal func didConnectPeripheral(_ connectedPeripheral: CBPeripheral) {
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
    
    internal func bleErrorHandler(_ error: BLEServiceErrors) {
        errorHandler?(error)
    }
}

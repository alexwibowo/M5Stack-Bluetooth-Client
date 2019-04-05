//
//  DeviceInfoHeaderView.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 23/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceInfoHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var labelDeviceName: UILabel!
    @IBOutlet weak var labelDeviceUUID: UILabel!
    @IBOutlet weak var labelConnectionState: UILabel!
    
    func configure(peripheral: CBPeripheral) {
        labelDeviceName.text = peripheral.name
        labelDeviceUUID.text = peripheral.identifier.uuidString
        labelConnectionState.text = "Connected"
    }

}

//
//  DeviceDetailsTableViewController.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 11/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit
import CoreBluetooth

enum Property {
    
}

class DeviceDetailsTableViewController: UITableViewController {
    
    var device: CBPeripheral!
    private var deviceInfo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.withClearFooter()
        
        deviceInfo.append(device.name ?? "NO NAME")
        deviceInfo.append(device.identifier.uuidString)
        device.services?.forEach({ (service) in
            deviceInfo.append(service.uuid.uuidString)
            service.characteristics?.forEach({ (characteristic) in
                deviceInfo.append("Characteristic uuid: \(characteristic.uuid)")
                deviceInfo.append(propertyList(properties: characteristic.properties))
            })
        })
    }
    
    private func propertyList(properties: CBCharacteristicProperties) -> String {
        if properties.contains(CBCharacteristicProperties.read) {
            return "read"
        }
        return "none"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = deviceInfo[indexPath.row]
        return cell
    }
}

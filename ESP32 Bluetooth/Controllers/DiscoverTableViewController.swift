//
//  DiscoverTableViewController.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 08/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit
import CoreBluetooth

class DiscoverTableViewController: UITableViewController {
    
    let service = BLEService(services: nil, options: nil)
    fileprivate var devices: [CBPeripheral] = []
//    fileprivate var deviceService: PeripheralService!
    
    var callback: ((CBPeripheral?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.withClearFooter()
        
        service.delegate = self
        
        service.devicesFound = { devices in
            if devices.count == 0 {
                self.alert(title: "No devices", msg: "No devices found")
                return
            }
            for device in devices {
                if device.name != nil {
                    self.devices.append(device)
                }
            }
            self.tableView.reloadData()
        }
        
//        service.deviceConnected = { device in
//            self.deviceService = PeripheralService(device)
//        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        cell?.textLabel?.text = devices[indexPath.row].name ?? "no name"
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = devices[indexPath.row]
        service.connect(peripheral: peripheral, options: nil) { _ in
            self.callback?(peripheral)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension DiscoverTableViewController: BLEServiceDelegate {
    func handleErrors(_ error: BLEServiceErrors) {
        switch error {
        case .poweredOff(let message):
            self.alert(title: "Error", msg: message)
        case .resetting(let message):
            self.alert(title: "Error", msg: message)
        case .unauthorized(let message):
            self.alert(title: "Error", msg: message)
        case .unknown(let message):
            self.alert(title: "Error", msg: message)
        case .unsupported(let message):
            self.alert(title: "Error", msg: message)
        }
    }
}

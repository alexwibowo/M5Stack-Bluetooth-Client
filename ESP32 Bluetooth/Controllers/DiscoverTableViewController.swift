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
    
    let bleService = BLEService(autostart: false)
    fileprivate var devices: [PeripheralData] = []
    
    var callback: ((CBPeripheral?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.withClearFooter()
        bleService.delegate = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let peripheralData = devices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = peripheralData.peripheral.name ?? "no name"
        cell.detailTextLabel?.text = "\(peripheralData.RSSI)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = devices[indexPath.row].peripheral
        bleService.connect(peripheral, options: nil)
    }
    
}

extension DiscoverTableViewController: BLEServiceDelegate {
    
    func didUpdateState(_ state: CBManagerState) {
        if state == .poweredOn {
            bleService.startScan()
        }
    }
    
    func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber) {
        
        // If the last update within one second, then ignore it
        let peripheralData = PeripheralData(peripheral: peripheral, RSSI: RSSI, advertisementData: advertisementData)
        if !self.devices.contains(peripheralData) {
            self.devices.append(peripheralData)
        } else {
            guard let index = self.devices.firstIndex(of: peripheralData) else {
                return
            }
            self.devices[index] = peripheralData
        }
        print("Bluetooth Manager --> didDiscoverPeripheral, RSSI:\(RSSI)")
        self.tableView.reloadData()
    }
    
    func didConnectPeripheral(_ connectedPeripheral: CBPeripheral) {
        self.callback?(connectedPeripheral)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
        // do nothing
    }
    
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
        case .noDevices(let message):
            self.alert(title: "Notice", msg: message)
        }
    }
}

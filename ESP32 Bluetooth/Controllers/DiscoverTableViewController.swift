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
    
    fileprivate let viewModel = DiscoverViewModel()
    fileprivate var devices: [Device] = []
    
    var callback: ((CBPeripheral?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DiscoverDeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "discoverCell")
        tableView.withClearFooter()
        
        viewModel.didDiscoverDevices = didDiscoverPeripherals
        viewModel.connectedDevice = connectedPeripheral
        viewModel.errorHandler = errorHandler
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unload()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let peripheralData = devices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverCell", for: indexPath) as! DiscoverDeviceTableViewCell
        cell.configure(peripheralData: peripheralData)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = devices[indexPath.row].peripheral
        viewModel.connect(peripheral: peripheral)
    }
    
    func didDiscoverPeripherals(_ peripheralsData: [Device]) {
        devices = peripheralsData.sorted(by: { $0.RSSI > $1.RSSI})
        tableView.reloadData()
    }
    
    func connectedPeripheral(_ peripheralData: Device) {
        self.callback?(peripheralData.peripheral)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func errorHandler(_ error: BLEServiceErrors) {
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

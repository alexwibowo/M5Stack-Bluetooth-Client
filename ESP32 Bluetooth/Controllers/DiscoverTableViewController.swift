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
    
    fileprivate var viewModel: DiscoverViewModel? = DiscoverViewModel()
    fileprivate var devices: [Device] = []
    
    var callback: ((CBPeripheral?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DiscoverDeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "discoverCell")
        tableView.withClearFooter()
        
        viewModel?.didDiscoverDevices = didDiscoverPeripherals
        viewModel?.connectedDevice = connectedPeripheral
        viewModel?.errorHandler = errorHandler
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel = nil
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
        cell.configure(withDevice: peripheralData)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = devices[indexPath.row].peripheral
        viewModel?.connect(peripheral: peripheral)
    }
    
    func didDiscoverPeripherals(_ peripheralsData: [Device]) {
        devices = peripheralsData.sorted(by: { $0.rssi > $1.rssi})
        tableView.reloadData()
    }
    
    func connectedPeripheral(_ peripheralData: Device) {
        self.callback?(peripheralData.peripheral)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func errorHandler(_ error: BLEServiceErrors) {
        switch error {
        case .poweredOff:
            self.alert(title: "poweredOff", msg: "Powered off")
        case .resetting:
            self.alert(title: "resetting", msg: "resetting")
        case .unauthorized:
            self.alert(title: "unauthorized", msg: "resetting")
        case .unknown:
            self.alert(title: "unknown", msg: "resetting")
        case .unsupported:
            self.alert(title: "Unsupported", msg: "resetting")
        case .noDevices:
            self.alert(title: "No devices", msg: "resetting")
        case .timeOut:
            self.alert(title: "Time out", msg: "resetting")
        }
    }
}

//
//  HomeTableViewController.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 22/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit
import CoreBluetooth

struct DeviceNames {
    static let TemperatureServiceUUID = "c594Ab00-4a4c-11e9-8646-d663bd873d93"
    static let TemperatureDataUUID = "c594Ab01-4a4c-11e9-8646-d663bd873d93"
    static let TemperatureConfig = "c594Ab02-4a4c-11e9-8646-d663bd873d93"
}

class HomeTableViewController: UITableViewController, BLEDelegate {

    let bleManager = BLEManager.shared
    @IBOutlet weak var tabButton: UIBarButtonItem!
    
    var tableItems: [String] = ["DeviceInfo", "Write data"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLEManager.Events.registerConnection(target: self, selector: #selector(self.respondeToNotification))
//        BLEManager.Events.registerDisconnection(target: self, selector: #selector(self.respondeToNotification))
        
        let headerNib = UINib.init(nibName: "DeviceInfoHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "DeviceInfoHeaderView")
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .backgroundColor = .clear
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DeviceInfoHeaderView") as! DeviceInfoHeaderView
            guard let peripheral = bleManager.connectedPeripheral else { return nil }
            headerView.configure(peripheral: peripheral)
            return headerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if bleManager.connectionState != .connected {
            return 0
        } else {
            if section == 0 {
                return 111.0
            }
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = tableItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let detailsViewController = UIStoryboard.deviceDetailsViewController()
            detailsViewController.peripheral = bleManager.connectedPeripheral
            navigationController?.pushViewController(detailsViewController, animated: true)
        case 1:
            if let services = bleManager.services, let characteristics = services.first?.characteristics {
              print(characteristics.count)
            }
            let writeViewController = UIStoryboard.writeDataViewController()
            writeViewController.services = bleManager.services
            navigationController?.pushViewController(writeViewController, animated: true)
        default:
            return
        }
    }
    
    @objc func respondeToNotification() {
        print(bleManager.connectedPeripheral?.name ?? "no name")
        tabButton.title = "Disconnect"
    }
    
    @IBAction func didTapDiscoverButton(_ sender: Any) {
        if bleManager.connectionState != .connected {
            let discoverViewController = UIStoryboard.discoverViewController()
            discoverViewController.callback = callback
            navigationController?.pushViewController(discoverViewController, animated: true)
        } else {
            bleManager.disconnectCurrentPeripheral()
        }
    }
    
    func callback(peripheral: CBPeripheral?) {
        print(bleManager.connectedPeripheral?.name ?? "no device")
        bleManager.delegate = self
        tableView.reloadData()
    }
    
    func didDisconnectPeripheral(_ peripheral: CBPeripheral) {
        tabButton.title = "Discover"
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.PeripheralConnected, object: nil)
    }
}

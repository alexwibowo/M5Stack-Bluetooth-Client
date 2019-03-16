//
//  ViewController.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 08/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit
import CoreBluetooth

class HomeViewController: UIViewController {
    
    let bleManager = BLEManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapDiscoverButton(_ sender: Any) {
        let discoverViewController = UIStoryboard.discoverViewController()
        discoverViewController.callback = callback
        navigationController?.pushViewController(discoverViewController, animated: true)
    }
    
    func callback(peripheral: CBPeripheral?) {
        print(bleManager.connectedPeripheral?.name ?? "no device")
    }
    @IBAction func didTapDetailsButton(_ sender: UIButton) {
        let detailsViewController = UIStoryboard.deviceDetailsViewController()
        detailsViewController.device = bleManager.connectedPeripheral
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

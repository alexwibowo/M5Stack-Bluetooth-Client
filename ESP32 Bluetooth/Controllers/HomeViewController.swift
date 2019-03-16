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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapDiscoverButton(_ sender: Any) {
        let discoverViewController = UIStoryboard.discoverViewController()
        navigationController?.pushViewController(discoverViewController, animated: true)
    }
}

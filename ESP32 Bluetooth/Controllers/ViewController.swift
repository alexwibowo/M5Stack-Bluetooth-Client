//
//  ViewController.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 08/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    fileprivate var deviceService: PeripheralService?
    let localStorage = LocalStorage()
    var service: BLEService?
    lazy var device = localStorage.getDevices()
    
    var peripheral: CBPeripheral? {
        didSet {
            guard let peripheral = self.peripheral else {
                return
            }
            self.statusLabel.text = self.peripheral?.name
            self.deviceService = PeripheralService(peripheral)
            self.deviceService?.didUpdateValue = { characteristic in
                
                if characteristic.uuid.uuidString == "DFB1" {
                    let stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
                    print(stringValue)
                }
            }
        }
    }
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        service = BLEService(services:nil, options: nil)
        
        if let device = localStorage.getDevices() {
            
            print(device)
            
            service?.devicesFound = { devices in
                if devices.count == 0 {
                    self.alert(title: "No devices", msg: "No devices found")
                    return
                }
                devices.forEach({ (device) in
                    if device.name == "Zibra ESP32" {
                        self.peripheral = device
                        self.service?.connect(peripheral: device, options: nil, completion: { (state) in
                            print("connected")
                        })
                    }
                })
            }
        }
        
    }
    
    @IBAction func didTapDiscoverButton(_ sender: Any) {
        let discoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverTableViewController") as! DiscoverTableViewController
        discoverViewController.callback = { peripheral in
            guard let connectedPeripheral = peripheral else {
                return
            }
            self.peripheral = connectedPeripheral
            self.localStorage.storeDevice(uuid: connectedPeripheral.identifier.uuidString)
        }
        navigationController?.pushViewController(discoverViewController, animated: true)
    }
    
    @IBAction func didTapSendMessageButton(_ sender: Any) {
        guard let characteristic = deviceService?.mainCharacteristics?.first else {
            return
        }
        
        deviceService?.writeData(characteristic: characteristic, data: "Hola".data(using: .utf8)!)
    }
    
    @IBAction func didTapReadMessageButton(_ sender: Any) {
        guard let characteristic = deviceService?.mainCharacteristics?.first else {
            return
        }
        deviceService?.readData(characteristic: characteristic)
    }
}

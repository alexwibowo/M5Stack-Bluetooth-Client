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
    
    var peripheral: CBPeripheral!
    private var deviceInfo: [String] = []
    let bleManager = BLEManager.shared
    fileprivate var services : [CBService]?
    fileprivate var characteristicsDic = [CBUUID : [CBCharacteristic]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.withClearFooter()
        
        deviceInfo.append(peripheral.name ?? "NO NAME")
        deviceInfo.append(peripheral.identifier.uuidString)
        bleManager.delegate = self
        bleManager.discoverCharacteristics()
        services = bleManager.connectedPeripheral?.services
        peripheral.readRSSI()
        
    }
    
    func getPropertiesFromArray(_ array : [String]) -> String {
        var propertiesString = "Properties:"
        let containWrite = array.contains("Write")
        for property in array {
            if containWrite && property == "Write Without Response" {
                continue
            }
            propertiesString += " " + property
        }
        return propertiesString
    }
    
    private func propertyList(properties: CBCharacteristicProperties) -> String {
        if properties.contains(CBCharacteristicProperties.read) {
            return "read"
        }
        return "none"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return bleManager.connectedPeripheral!.services!.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Device Info"
        } else {
            return "Services"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return deviceInfo.count
        } else {
            if characteristicsDic.count == 0 {
                return 0
            }
            let characteristics = characteristicsDic[services![section - 1].uuid]
            return characteristics == nil ? 0 : characteristics!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = deviceInfo[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            let characteristic = characteristicsDic[services![indexPath.section - 1].uuid]![indexPath.row]
            cell.textLabel?.text = characteristic.name
            cell.detailTextLabel?.text = getPropertiesFromArray(characteristic.properties.names)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section < 1 {
            return
        }
        
        self.confirm(msg: "Set notify") { (status) in
            if  let serviceUUID = self.services?[0].uuid {
                let characteristics = self.characteristicsDic[serviceUUID]
                guard let characteristic = characteristics?[indexPath.row] else {
                    print("no characteristic")
                    return
                }
                self.peripheral.setNotifyValue(status, for: characteristic)
            }
        }
    }
}


extension DeviceDetailsTableViewController: BLEDelegate {
    
    func didDiscoverCharacteritics(_ service: CBService) {
        
        print("Service.characteristics:\(service.characteristics?.description ?? "Unknow Characteristics")")
        characteristicsDic[service.uuid] = service.characteristics
        
//        guard let characteristics = service.characteristics else {
//            return
//        }
//
//        var enableValue:UInt8 = 1
//        let enableBytes = Data(bytes: &enableValue, count: sizeof(UInt8.self))
        
//        for characteristic in characteristics {
//            peripheral?.setNotifyValue(false, for: characteristic)
//            peripheral?.writeValue(enableBytes, for: characteristic, type: .withResponse)
//        }
        
        tableView.reloadData()
    }
    
    func didReadValueForCharacteristic(_ characteristic: CBCharacteristic) {
        print("\(characteristic.uuid) - \(characteristic.value)")
    }
}


func sizeof <T> (_ : T.Type) -> Int
{
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ : T) -> Int
{
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ value : [T]) -> Int
{
    return (MemoryLayout<T>.size * value.count)
}

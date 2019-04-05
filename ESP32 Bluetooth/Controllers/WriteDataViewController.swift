//
//  WriteDataViewController.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 23/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit
import CoreBluetooth

class WriteDataViewController: UIViewController {
    
    @IBOutlet weak var labelValue: UITextField!
    @IBOutlet weak var buttonWrite: UIButton!
    @IBOutlet weak var pickerCharacteristics: UIPickerView!
    @IBOutlet weak var labelSelected: UILabel!
    
    var services: [CBService]?
    private var characteristics: [CBCharacteristic] = []
    private var selectedCharacteristic: CBCharacteristic?
    
    let bleManager = BLEManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerCharacteristics.dataSource = self
        pickerCharacteristics.delegate = self
        
        bleManager.delegate = self
        
        self.hideKeyboard()
        
        if let characteristics = services?.first?.characteristics {
            self.characteristics = characteristics
            pickerCharacteristics.reloadAllComponents()
        }
    }
    
    @IBAction func writeValue() {
        guard let characteristic = selectedCharacteristic else {
            return
        }
        
        guard let text = labelValue.text, let data = text.data(using: .utf8) else { return }
        
        bleManager.write(data, for: characteristic)
    }
    
    @IBAction func didChangeValue(_ sender: UISwitch) {
        guard let characteristic = selectedCharacteristic else {
            return
        }
        let value: String = sender.isOn ? "ON" : "OFF"
        let data = value.data(using: .utf8)!
        bleManager.write(data, for: characteristic)
    }
    
}

extension WriteDataViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return characteristics.count
    }
}

extension WriteDataViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return characteristics[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCharacteristic = characteristics[row]
        labelSelected.text = "selected: \(characteristics[row].name)"
    }
}


extension WriteDataViewController: BLEDelegate {
    func didWriteValueForCharacteristic(_ characteristic: CBCharacteristic) {
        print("write value")
    }
}

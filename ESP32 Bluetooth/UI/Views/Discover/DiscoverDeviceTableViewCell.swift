//
//  DiscoverDeviceTableViewCell.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 15/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit

class DiscoverDeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPeripheralName: UILabel!
    @IBOutlet weak var labelRssi: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        labelPeripheralName.text = ""
        labelRssi.text = ""
    }
    
    func configure(withDevice device: Device) {
        labelPeripheralName.text = device.peripheral.name ?? "UNKNOWN"
        labelRssi.text = "\(device.rssi)"
    }
    
}

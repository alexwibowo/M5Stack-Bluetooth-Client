//
//  CBCharacteristics.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 18/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import CoreBluetooth

extension CBCharacteristic {

    // Obtain the name of the characteristic according to the UUID, if the UUID is the standard defined in the `Bluetooth Developer Portal` then return the name
    public var name : String {
        guard let name = self.uuid.name else {
            return "0x" + self.uuid.uuidString
        }
        return name
    }
}

extension CBCharacteristicProperties {
    public var names: [String] {
        var resultProperties = [String]()
        if contains(.broadcast) {
            resultProperties.append("Broadcast")
        }
        if contains(.read) {
            resultProperties.append("Read")
        }
        if contains(.write) {
            resultProperties.append("Write")
        }
        if contains(.writeWithoutResponse) {
            resultProperties.append("Write Without Response")
        }
        if contains(.notify) {
            resultProperties.append("Notify")
        }
        if contains(.indicate) {
            resultProperties.append("Indicate")
        }
        if contains(.authenticatedSignedWrites) {
            resultProperties.append("Authenticated Signed Writes")
        }
        if contains(.extendedProperties) {
            resultProperties.append("Extended Properties")
        }
        if contains(.notifyEncryptionRequired) {
            resultProperties.append("Notify Encryption Required")
        }
        if contains(.indicateEncryptionRequired) {
            resultProperties.append("Indicate Encryption Required")
        }
        return resultProperties
    }
}

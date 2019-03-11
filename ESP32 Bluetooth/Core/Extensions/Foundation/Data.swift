//
//  Data.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import Foundation

// MARK: - Data extension
extension Data {
    
    /// Mime type signatures property
    private static let mimeTypeSignatures: [UInt8: String] = [
        0xFF: "image/jpeg",
        0x89: "image/png",
        0x47: "image/gif",
        0x49: "image/tiff",
        0x4D: "image/tiff",
        0x25: "application/pdf",
        0xD0: "application/vnd",
        0x46: "text/plain",
    ]

    /// Mime type property
    var mimeType: String {
        var mimeBytes: UInt8 = 0
        copyBytes(to: &mimeBytes, count: 1)
        return Data.mimeTypeSignatures[mimeBytes] ?? "application/octet-stream"
    }
}

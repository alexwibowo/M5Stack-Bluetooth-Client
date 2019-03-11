//
//  RNColors.swift
//  RouteNavigator
//
//  Created by Mac Ward on 17/07/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

// MARK: - UIColor extension
extension UIColor {

    /// Custom RGB initializer
    ///
    /// - Parameters:
    ///   - red: `Int` value
    ///   - green: `Int` value
    ///   - blue: `Int` value
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    /// Custom Hex initializer
    ///
    /// - Parameter netHex: `Int` value
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xFF, green: (netHex >> 8) & 0xFF, blue: netHex & 0xFF)
    }

    /// App colors template
    struct AppColors {
        /// 0x3D3D3D static UIColor
        static let InputGray = UIColor(netHex: 0x3D3D3D)
        /// 0x4E4E4E static UIColor
        static let InputLineGray = UIColor(netHex: 0x4E4E4E)
        /// 0x232222 static UIColor
        static let RNSeparatorColor = UIColor(netHex: 0x232222)
        /// 0x1E1E20 static UIColor
        static let tabBarBackground = UIColor(netHex: 0x1E1E20)
        /// 0xFFD119 static UIColor
        static let yellow = UIColor(netHex: 0xFFD119)
        /// 0x272728 static UIColor
        static let tabBarRoundedButton = UIColor(netHex: 0x272728)
        /// 0x0C0C0C static UIColor
        static let darkGrayBackground = UIColor(netHex: 0x0C0C0C)
        /// 0x1D1D1D static UIColor
        static let darkGraySelection = UIColor(netHex: 0x1D1D1D)
        /// 0xEFEFF4 static UIColor
        static let liteGray = UIColor(netHex: 0xEFEFF4)
        // Serch Bar
        /// 0x303034 static UIColor
        static let searchBarTextBackground = UIColor(netHex: 0x303034)
        /// 0xAEAFB0 static UIColor
        static let searchBarTextColor = UIColor(netHex: 0xAEAFB0)
        // Route Status
        /// 0x4E4E4E static UIColor
        static let pendingStatus = UIColor(netHex: 0x4E4E4E)
        /// 0xC75656 static UIColor
        static let notOutStatus = UIColor(netHex: 0xC75656)
        /// 0x53C191 static UIColor
        static let completedStatus = UIColor(netHex: 0x53C191)
        /// 0x638BBF static UIColor
        static let skipReasonStatus = UIColor(netHex: 0x638BBF)
        /// 0x35D2A9 static UIColor
        static let pickupStatus = UIColor(netHex: 0x35D2A9)
        /// 0x355ED2 static UIColor
        static let holdStatus = UIColor(netHex: 0x355ED2)
        /// 0x355ED2 static UIColor
        static let deliverStatus = UIColor(netHex: 0x355ED2)
        /// 0xd10808 static UIColor
        static let darkRed = UIColor(netHex: 0xd10808)
    }
}

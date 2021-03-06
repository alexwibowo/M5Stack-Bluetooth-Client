//
//  Storyboard.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 14/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /// Get Main story board
    ///
    /// - Returns: return `UIStoryboard` object
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    /// Get HomeViewController
    ///
    /// - Returns: return `HomeViewController` object
    class func HomeTableViewController() -> HomeTableViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
    }
    
    /// Get DiscoverTableViewController
    ///
    /// - Returns: return `DiscoverTableViewController` object
    class func discoverViewController() -> DiscoverTableViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "DiscoverTableViewController") as! DiscoverTableViewController
    }
    
    // Get DiscoverTableViewController
    ///
    /// - Returns: return `DiscoverTableViewController` object
    class func deviceDetailsViewController() -> DeviceDetailsTableViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "DeviceDetailsTableViewController") as! DeviceDetailsTableViewController
    }
    
    class func writeDataViewController() -> WriteDataViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "WriteDataViewController") as! WriteDataViewController
    }
    
}

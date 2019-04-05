//
//  UIColor.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 17/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit

extension UIColor {
    struct ThemeDefault {
        
    }
}



// MARK: - UIColor extension
extension UIColor {
    
    /// Very light gray color
    ///
    /// - Returns: return `UIColor` object
    static func veryLightGray() -> UIColor {
        return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
    }
    
    /// Turquoise color
    ///
    /// - Returns: return `UIColor` object
    static func turquoise() -> UIColor {
        return UIColor(red: 0.40, green: 0.81, blue: 0.87, alpha: 1.00)
    }
    
    /// Purple star color
    ///
    /// - Returns: return `UIColor` object
    static func purpleStar() -> UIColor {
        return UIColor(red: 152 / 255, green: 51 / 255, blue: 238 / 255, alpha: 1)
    }
    
    /// Red archive color
    ///
    /// - Returns: return `UIColor` object
    static func redArchive() -> UIColor {
        return UIColor(red: 209 / 255, green: 19 / 255, blue: 26 / 255, alpha: 1)
    }
    
    /// Green Got it color
    ///
    /// - Returns: return `UIColor` object
    static func greenGotIt() -> UIColor {
        return UIColor(red: 90 / 255, green: 174 / 255, blue: 49 / 255, alpha: 1)
    }
    
    /// Orange bought it color
    ///
    /// - Returns: return `UIColor` object
    static func orangeBoughtIt() -> UIColor {
        return UIColor(red: 0.98, green: 0.65, blue: 0.27, alpha: 1.00)
    }
    
    /// Table view background color
    ///
    /// - Returns: return `UIColor` object
    static func tableViewBackground() -> UIColor {
        return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    }
    
    /// Separator color
    ///
    /// - Returns: return `UIColor` object
    static func separatorColor() -> UIColor {
        return UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
    }
    
    /// Header title blue color
    ///
    /// - Returns: return `UIColor` object
    static func headerTitleBlue() -> UIColor {
        return UIColor(red: 0.01, green: 0.56, blue: 0.65, alpha: 1)
    }
    
    /// Header detail title gray color
    ///
    /// - Returns: return `UIColor` object
    static func headerDetailTitleGray() -> UIColor {
        return UIColor.gray
    }
    
    /// Star red color
    ///
    /// - Returns: return `UIColor` object
    static func starRedColor() -> UIColor {
        return UIColor(red: 0.76, green: 0.23, blue: 0.48, alpha: 1.00)
    }
    
    /// Tag selected color
    ///
    /// - Returns: return `UIColor` object
    static func tagSelectedColor() -> UIColor {
        return UIColor(red: 89 / 255, green: 200 / 255, blue: 250 / 255, alpha: 1)
    }
    
    /// Tag unselected color
    ///
    /// - Returns: return `UIColor` object
    static func tagUnSelectedColor() -> UIColor {
        return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    /// Border button color
    ///
    /// - Returns: return `UIColor` object
    static func borderButtonColor() -> UIColor {
        return UIColor(red: 0.91, green: 1.11, blue: 1.55, alpha: 0.7)
    }
}

//
//  Integer.swift
//  RouteNavigator
//
//  Created by Mac Ward on 16/11/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import Foundation


// MARK: - Int extension
extension Int {
    
    /// Convert int value 1 or 0 to Bool state
    ///
    /// - Returns: return `Bool` state
    func boolValue() -> Bool {
        if self == 0 {
            return false
        }
        return true
    }
}

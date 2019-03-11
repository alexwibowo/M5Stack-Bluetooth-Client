//
//  Realm.swift
//  RouteNavigator
//
//  Created by Mac Ward on 28/10/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Results extension
extension Results {
    
    /// Results extension to transform self into any Object array
    ///
    /// - Parameter type: generic object type
    /// - Returns: return generic object array
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}

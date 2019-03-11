//
//  Bundle.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import Foundation

// MARK: - Bundle extension
extension Bundle {
    
    /// Bundle realise version number description
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /// Bundle build version number description
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    /// Bundle base URL description
    var baseURL: String {
        return infoDictionary?["API_BASE_URL"] as! String
    }

    /// Bundle delete if migration state
    var deleteDBIfMigrationNeeded: Bool {
//        return infoDictionary?["DELETE_IF_MIGRATION"] as! Bool
        return true
    }
}

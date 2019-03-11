//
//  Dictionary.swift
//  RouteNavigator
//
//  Created by Mac Ward on 26/02/2019.
//  Copyright © 2019 webwerks. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
    /// Get string from JSON
    ///
    /// - Parameter paramDict: `String`:`AnyObject` objects array
    /// - Returns: return `String` value
    func JSONString() -> String {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            print("JSON string = \(theJSONText!)")
            return NormalizeJSONString(theJSONText!)
        }
        return ""
    }
    
    /// Convert string to dictionary
    ///
    /// - Parameter text: `String` value
    /// - Returns: return `String`:`AnyObject` objects array or `nil`
    func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    /// Replace ocurrences associated to a string
    ///
    /// - Parameter str: `String` value
    /// - Returns: return `String` value
    fileprivate func NormalizeJSONString(_ str: String) -> String {
        // stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        return str.replacingOccurrences(of: "\\", with: "")
    }
}

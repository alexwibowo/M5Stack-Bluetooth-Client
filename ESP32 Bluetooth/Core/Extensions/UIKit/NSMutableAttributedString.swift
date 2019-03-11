//
//  NSMutableAttributedString.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

// MARK: - NSMutableAttributedString extension
extension NSMutableAttributedString {
    
    /// Add bold atribbute to a text string
    ///
    /// - Parameter text: `String` value
    /// - Returns: return `NSMutableAttributedString` object
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 17.0)]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        append(boldString)

        return self
    }

    /// Add nolmal atribbute to a text string
    ///
    /// - Parameter text: `String` value
    /// - Returns: return `NSMutableAttributedString` object
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)

        return self
    }
}

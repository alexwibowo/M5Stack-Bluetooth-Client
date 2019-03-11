//
//  UIView+Nib.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

// MARK: - UIView extension
extension UIView {

    /// Instantiate a UINib
    ///
    /// - Returns: return `UIView` object or `nil`
    class func instanceFromNib() -> UIView? {
        guard let view = UINib(
            nibName: String(
                describing: self),
            bundle: nil).instantiate(
            withOwner: nil,
            options: nil)[0] as? UIView
        else {
            return nil
        }

        return view
    }

    /// Instantiate a UINib with a nib name
    ///
    /// - Parameter nibName: `String` value
    /// - Returns: return `UIView` object or `nil`
    class func instanceFromNib(withName nibName: String) -> UIView? {
        guard let view = UINib(
            nibName: nibName,
            bundle: nil).instantiate(
            withOwner: nil,
            options: nil)[0] as? UIView
        else {
            return nil
        }

        return view
    }
}

//
//  UIViewController+Alerts.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UIViewController extension
extension UIViewController {

    /// Confirm alert withput title and with escaping action handler closure
    ///
    /// - Parameters:
    ///   - msg: `String` value
    ///   - handler: escaping void clousure
    func confirm(msg: String, handler: @escaping (_ yes: Bool) -> Void) {

        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            handler(true)
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            handler(false)
        }))

        present(alert, animated: true, completion: nil)
    }

    /// Alert
    ///
    /// - Parameters:
    ///   - title: `String` value
    ///   - msg: `String` value
    func alert(title: String, msg: String) {
        alert(title: title, msg: msg, completion: nil)
    }

    /// Alert with OK action completion closure
    ///
    /// - Parameters:
    ///   - title: `String` value
    ///   - msg: `String` value
    ///   - completion: completion void closure or `nil`
    func alert(title: String, msg: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            completion?()
        }))

        present(alert, animated: true, completion: nil)
    }
}

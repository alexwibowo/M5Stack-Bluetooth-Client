//
//  ViewController+Accessibility.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

// MARK: - UIViewController extension
extension UIViewController {

    /// Add accessibility label
    func addAccessibilityLabelToTabBarItem() {
        if tabBarController != nil {
            if tabBarController!.tabBarItem != nil {
                tabBarController!.tabBarItem.accessibilityLabel = navigationItem.title
            }
        }
    }
}

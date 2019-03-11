//
//  UINavigationController.swift
//  RouteNavigator
//
//  Created by Mac Ward on 22/10/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

/// BackButtonHandlerDelegate protocol
public protocol BackButtonHandlerDelegate {
    /// Should pop on back button action
    ///
    /// - Returns: return Bool state
    func shouldPopOnBackButton() -> Bool
    /// Display a message
    func displayMessage()
}

// MARK: - <#UINavigationBarDelegate#> extension
extension UINavigationController: UINavigationBarDelegate  {
    
    /// Manage alert confirmation qhen navigate back
    ///
    /// - Parameters:
    ///   - navigationBar: `UINavigationBar` object
    ///   - item: `UINavigationItem` object
    /// - Returns: return `Bool` state
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        if viewControllers.count < (navigationBar.items?.count) ?? 0 {
            return true
        }
        
        var shouldPop = true
        let vc = self.topViewController
        
        if let vc = vc as? BackButtonHandlerDelegate {
            shouldPop = vc.shouldPopOnBackButton()
            if shouldPop == false {
                vc.displayMessage()
            }
        }
        
        if shouldPop {
            DispatchQueue.main.async {[weak self] in
                _ = self?.popViewController(animated: true)
            }
        } else {
            for subView in navigationBar.subviews {
                if(0 < subView.alpha && subView.alpha < 1) {
                    UIView.animate(withDuration: 0.25, animations: {
                        subView.alpha = 1
                    })
                }
            }
            
        }
        
        return false
    }
}

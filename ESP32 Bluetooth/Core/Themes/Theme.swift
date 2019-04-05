//
//  Theme.swift
//  ESP32 Bluetooth
//
//  Created by Mac Ward on 16/03/2019.
//  Copyright © 2019 Mac Ward. All rights reserved.
//

import UIKit

protocol Theme {
    var tint: UIColor { get }
    var secondaryTint: UIColor { get }
    
    var backgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectionColor: UIColor { get }
    
    // navigation bar
    var navigationBarBackground: UIColor { get }
    
    // tab bar
    
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var subtleLabelColor: UIColor { get }
    
    var barStyle: UIBarStyle { get }
    
    func apply(for application: UIApplication)
    func extend()
}

extension Theme {
    
    func apply(for application: UIApplication) {
        
        application.keyWindow?.tintColor = tint
        
        UITabBar.appearance().tintColor = tint
        
        UINavigationBar.appearance().tintColor = .red
        UINavigationBar.appearance().backgroundColor = .red
        UINavigationBar.appearance().isTranslucent = false
        
//        if #available(iOS 11.0, *) {
//        UINavigationBar.appearance().largeTitleTextAttributes = [
//            .foregroundColor: labelColor
//        ]
//        }
        UICollectionView.appearance().backgroundColor = backgroundColor
        
        UITableView.appearance().backgroundColor = backgroundColor
        
        UITableViewCell.appearance().backgroundColor = .clear
        
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .backgroundColor = selectionColor
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = secondaryLabelColor
        
        extend()
        
        // Ensure existing views render with new theme
        // https://developer.apple.com/documentation/uikit/uiappearance
    }
    
    func extend() {
        // Optionally extend theme
    }
}

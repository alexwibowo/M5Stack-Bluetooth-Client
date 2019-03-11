//
//  UITableView.swift
//  RouteNavigator
//
//  Created by Mac Ward on 15/10/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

// MARK: - UITableView extension
extension UITableView {
    /// Remove footer from table view
    func withClearFooter() {
        tableFooterView = UIView()
    }
}

//
//  UIView+Nib.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

/// Custom button control
class Button: UIButton {

    typealias DidTapButton = (Button) -> Void

    /// Manage button action when press it
    var didTouchUpInside: DidTapButton? {
        didSet {
            if didTouchUpInside != nil {
                addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            }
        }
    }

    // MARK: - Actions

    /// Handler didTouchUpInside actoin
    ///
    /// - Parameter _: `UIButton` object
    @objc func didTouchUpInside(_: UIButton) {
        if let handler = didTouchUpInside {
            handler(self)
        }
    }
}

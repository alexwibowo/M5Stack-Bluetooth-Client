//
//  DownStateButton.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

/// Custom radio button
class RadioButton: UIButton {

    var alternateButton: [RadioButton]?

    /// Custom down state image
    let downStateImage = "RadioCheck.png"
    /// Custom up state image
    let upStateImage = "RadioUncheck.png"

    override func awakeFromNib() {
        // self.layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    /// Custom unselect handling
    func unselectAlternateButtons() {
        if alternateButton != nil {
            isSelected = true

            for aButton in alternateButton! {
                aButton.isSelected = false
            }
        } else {
            toggleButton()
        }
    }

    /// Custom touch handling
    ///
    /// - Parameters:
    ///   - touches: Set<UITouch> object
    ///   - event: `UIEvent` object or `nil`
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }

    /// Change isSelected property state
    func toggleButton() {
        isSelected = !isSelected
    }

    /// Add isSelected property
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setImage(UIImage(named: downStateImage), for: .selected)
            } else {
                setImage(UIImage(named: upStateImage), for: .selected)
            }
        }
    }
}

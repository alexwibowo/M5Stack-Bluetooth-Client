//
//  UIScreen.swift
//  RouteNavigator
//
//  Created by Mac Ward on 27/07/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    var verticalSize: CGFloat {
        let height = bounds.size.height
        return height
    }
}

public enum ScreenSize: CGFloat {
    case iPhoneSE = 568
    case iPhone = 667
    case iPhonePlus = 736
    case iPhoneX = 812
}

//
//  CAGradientLayer.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

// MARK: - CAGradientLayer extension
extension CAGradientLayer {

    /// Custom initializer
    ///
    /// - Parameters:
    ///   - frame: `CGRect` object
    ///   - colors: `UIColor` objects array
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }

    /// Create gradient image
    ///
    /// - Returns: return `UIImage` object or nill
    func createGradientImage() -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }

    /// Create gradient with template associated to a CGRect object
    ///
    /// - Parameters:
    ///   - bounds: `CGRect` object
    ///   - color: `String` template value
    /// - Returns: return `CAGradientLayer` object
    static func createGradient(bounds: CGRect, color: String) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds

        switch color {
        case "Blue":
            gradient.colors = [
                UIColor(red: 0.17, green: 0.78, blue: 0.91, alpha: 1).cgColor,
                UIColor(red: 0.01, green: 0.63, blue: 0.87, alpha: 1).cgColor,
            ]
        case "Yellow":
            gradient.colors = [
                UIColor(red: 1, green: 0.78, blue: 0.22, alpha: 1).cgColor,
                UIColor.orange.cgColor,
            ]
        case "Red":
            gradient.colors = [
                UIColor(red: 0.9, green: 0.18, blue: 0.15, alpha: 1).cgColor,
                UIColor(red: 0.7, green: 0.07, blue: 0.09, alpha: 1).cgColor,
            ]
        case "BlueDark":
            gradient.colors = [
                UIColor(red: 0.23, green: 0.35, blue: 0.6, alpha: 1).cgColor,
                UIColor(red: 0.17, green: 0.25, blue: 0.44, alpha: 1).cgColor,
            ]
        default:
            gradient.colors = [
                UIColor(red: 0.17, green: 0.78, blue: 0.91, alpha: 1).cgColor,
                UIColor(red: 0.01, green: 0.63, blue: 0.87, alpha: 1).cgColor,
            ]
        }

        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.99)

        return gradient
    }
}

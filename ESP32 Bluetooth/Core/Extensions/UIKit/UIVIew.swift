//
//  UIVIew.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import UIKit

// MARK: - UIView extension
extension UIView {

    /// Get self class identifier
    ///
    /// - Returns: return `String` value
    static func classIdentifier() -> String {
        return String(describing: self)
    }

    /// Add a gradient sublayer associated to a view and a color
    ///
    /// - Parameters:
    ///   - view: `UIView` object
    ///   - color: `String` value
    /// - Returns: return `CAGradientLayer` object
    static func addGradientButton(_ view: UIView, color: String) -> CAGradientLayer {
        let gradientButton = CAGradientLayer.createGradient(bounds: view.bounds, color: color)
        view.layer.cornerRadius = 4
        gradientButton.cornerRadius = 4
        gradientButton.shadowOffset = CGSize(width: 0, height: 8)
        gradientButton.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        gradientButton.shadowOpacity = 1
        gradientButton.shadowRadius = 20
        view.layer.insertSublayer(gradientButton, at: 0)
        return gradientButton
    }

    @IBInspectable
    /// Add corner radius propertie
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    /// Add border color propertie
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    /// Add border color propertie
    var borderColor: UIColor? {
        get {

            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

// MARK: - UIView extension
extension UIView {

    @IBInspectable
    /// Add shadow radius propertie
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
}

//
// View for UILabel Accessory
//

// MARK: - UIView extension
extension UIView {

    /// Get a check valid image
    ///
    /// - Returns: return `UIView` object
    func rightValidAccessoryView() -> UIView {
        let imgView = UIImageView(image: UIImage(named: "check_valid"))
        imgView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imgView.backgroundColor = UIColor.clear
        return imgView
    }

    /// Get a check invalid image
    ///
    /// - Returns: return `UIView` object
    func rightInValidAccessoryView() -> UIView {
        let imgView = UIImageView(image: UIImage(named: "check_invalid"))
        imgView.frame = CGRect(x: cornerRadius, y: cornerRadius, width: 20, height: 20)
        imgView.backgroundColor = UIColor.clear
        return imgView
    }

    /// Add contraint to container frame
    ///
    /// - Parameter container: `UIView` object
    func fixInView(_ container: UIView!) {
        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

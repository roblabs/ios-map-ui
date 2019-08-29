//
//  Extensions.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func activateAnchors(for size: CGSize) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size.height),
            widthAnchor.constraint(equalToConstant: size.width)
            ])
    }
    
    func pin(to parentV: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentV.topAnchor),
            leftAnchor.constraint(equalTo: parentV.leftAnchor),
            rightAnchor.constraint(equalTo: parentV.rightAnchor),
            bottomAnchor.constraint(equalTo: parentV.bottomAnchor)
            ])
    }
}

extension UIViewController {
    func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension UIImage {
    func resize(to targetSize: CGSize) -> UIImage {
        let size = self.size
        
        // figure out orientation
        let wRatio  = targetSize.width / size.width
        let hRatio = targetSize.height / size.height
        let ratio = min(hRatio, wRatio)
        
        // draw new rect based on orientation
        let w = size.width * ratio
        let h = size.height * ratio
        let newSize = CGSize(width: w, height: h)
        let rect = CGRect(origin: .zero, size: newSize)
        
        // resize rect within context
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = image?.withRenderingMode(.alwaysTemplate)
        image = templateImage
        tintColor = color
    }
}

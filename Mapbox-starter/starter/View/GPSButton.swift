//
//  GPSButton.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import UIKit

class GPSButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // size image to button with insets
        imageEdgeInsets = imageInsets
        
        // when button in selected state, will read as enabled
        // in normal state, will be disabled
        setImage(disabledImage, for: .normal)
        setImage(enabledImage, for: .selected)
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        
        // when performing it's action, will toggle whether selected or not
        isSelected = !isSelected
    }
    
}

extension GPSButton {
    
    private struct ImageString {
        static let notTracking = "GPS_icon"
        static let tracking = "GPSfilled_icon"
    }
    
    private var imageInsets: UIEdgeInsets {
        let inset = frame.size.height / 4
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    private var disabledImage: UIImage { return image(enabled: false) }
    private var enabledImage: UIImage { return image(enabled: true) }
    
    private func image(enabled: Bool) -> UIImage {
        var str = ImageString.notTracking // default to not tracking
        if enabled { str = ImageString.tracking }
        let img = UIImage(named: str)!
        return img.withRenderingMode(.alwaysTemplate)
    }
    
}

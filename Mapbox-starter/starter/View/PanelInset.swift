//
//  PanelInset.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import UIKit

struct PanelInset {
    static let full = Default.padding
    
    static var half: CGFloat {
        // take lesser of 2 screen values, because is based on screen bounds
        // if you take the screen height on landscape rotation, will be taller than screen
        let lesser = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        return lesser / 2
    }
    
    static let tip = (Default.grabberInset * 2) + Default.searchBarHeight
}

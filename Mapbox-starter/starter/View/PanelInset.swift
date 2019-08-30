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
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight / 2
    }
    
    static let tip = (Default.grabberInset * 2) + Default.searchBarHeight
}

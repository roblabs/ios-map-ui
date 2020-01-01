//
//  PlaceCategory+Service.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import UIKit

extension PlaceCategory {
    
    var title: String {
        switch self {
        case .wild: return "Wild"
        case .camp: return "Camp"
        case .misc: return "Misc"
        }
    }
    
    var imageString: String {
        switch self {
        case .wild: return "wilderness_icon"
        case .camp: return "camp_icon"
        case .misc: return "marker_icon"
        }
    }
    
    var color: UIColor {
        switch self {
        case .wild: return .systemGreen
        case .camp: return .systemOrange
        case .misc: return .systemYellow
        }
    }
    
    var image: UIImage? {
        return UIImage(named: imageString)
    }
    
}

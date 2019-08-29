//
//  Default.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Default {
    static let style = MapStyleCollection.allStyles.first!
    static let center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    static let padding: CGFloat = 16
    static let cornerRadius: CGFloat = padding
    static let animationDuration: TimeInterval = 0.2
    static let searchBarHeight: CGFloat = 44
    static let grabberPadding: CGFloat = 6 // default value for FPC's top padding
    static let grabberHandleHeight: CGFloat = 5 // default value for FPC's grabber handle height
    static var grabberInset: CGFloat { return grabberHandleHeight + (grabberPadding * 2) } // computed variable for FPC grabber inset
}

extension UserDefaults {
    
    var mapStyle: MapStyle {
        guard let data = value(forKey: "mapStyle") as? Data
            else { return Default.style }
        
        let decoder = JSONDecoder()
        let style = try? decoder.decode(MapStyle.self, from: data)
        
        return style ?? Default.style
    }
    
    func setStyle(to style: MapStyle) {
        let encoder = JSONEncoder()
        
        guard let encodedStyle = try? encoder.encode(style)
            else { return }
        
        set(encodedStyle, forKey: "mapStyle")
    }
}


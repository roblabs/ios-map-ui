//
//  Map.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

class Map {
    var title: String = "My Map"
    var boundaries: MapBoundaries
    var mappedPlaces = Set<Place>()
    
    init(boundaries: MapBoundaries) {
        self.boundaries = boundaries
    }
    
    var style: MapStyle {
        get {
            return UserDefaults.standard.mapStyle
        }
        
        set(newStyle) {
            UserDefaults.standard.setStyle(to: newStyle)
        }
    }
}

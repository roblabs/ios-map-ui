//
//  MapViewModel.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import Mapbox

private let currentFile = File(name: "points", type: "geojson")

class MapViewModel {
    let map: Map
    
    init() throws {
        self.map = try DataService.fetchData(of: currentFile)
    }
    
    var annotations: [PlaceAnnotation] {
        return map.mappedPlaces.map { PlaceAnnotation(mapped: $0) }
    }
    
    func updateStyle(to style: MapStyle) {
        map.style = style
    }
}

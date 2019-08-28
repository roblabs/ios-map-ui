//
//  MapBoundaries.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

struct MapBoundaries {
    var northLat: Double
    var southLat: Double
    var eastLong: Double
    var westLong: Double
    
    var center: Location {
        let vBounds = [northLat, southLat]
        let hBounds = [westLong, eastLong]
        let midLat = vBounds.avg()
        let midLong = hBounds.avg()
        return Location(latitude: midLat, longitude: midLong)
    }
}

extension Array where Element == Double {
    func avg() -> Double {
        let sum = reduce(0.0, +)
        return sum / Double(count)
    }
}

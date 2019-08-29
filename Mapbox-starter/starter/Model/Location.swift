//
//  Location.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

struct Location: Hashable {
    var latitude: Double
    var longitude: Double
}

extension Location {
    var isValid: Bool {
        return latitude.isValidLatitude && longitude.isValidLongitude
    }
}

extension Double {
    var isValidLatitude: Bool { return self < 90 && -90 < self }
    var isValidLongitude: Bool { return self < 180 && -180 < self }
}

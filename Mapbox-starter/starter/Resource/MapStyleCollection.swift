//
//  MapStyleCollection.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

struct MapStyleCollection {
    // load Map Styles locally here 
    static let allStyles: [MapStyle] = [
        MapStyle(
            title: "Streets",
            urlString: "mapbox://styles/mapbox/streets-v11"
        ),
        MapStyle(
            title: "Light",
            urlString: "mapbox://styles/mapbox/light-v9"
        ),
        MapStyle(
            title: "Satellite",
            urlString: "mapbox://styles/mapbox/satellite-v9"
        ),
    ]
}

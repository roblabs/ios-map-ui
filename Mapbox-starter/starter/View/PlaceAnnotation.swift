//
//  PlaceAnnotation.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import Mapbox

class PlaceAnnotation: NSObject, MGLAnnotation {
    let place: Place
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var category: PlaceCategory
    
    init(mapped: Place) {
        self.place = mapped
        self.category = mapped.category
        self.coordinate = mapped.location.clCoord
        self.title = mapped.title
        self.subtitle = mapped.description
    }
    
    var image: UIImage?
    var reuseIdentifier: String?
}

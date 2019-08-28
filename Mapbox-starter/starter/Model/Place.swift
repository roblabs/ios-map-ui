//
//  Place.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

struct Place: Hashable {
    let title: String
    let description: String?
    let location: Location
    let category: PlaceCategory
}

extension Place: Comparable {
    static func < (lhs: Place, rhs: Place) -> Bool {
        // places sorted by title
        return lhs.title < rhs.title
    }
}

extension Place {
    init?(from fDict: [String: AnyObject]) {
        guard
            let geo = fDict["geometry"] as? [String: AnyObject],
            let coords = geo["coordinates"] as? NSArray,
            let lat = coords[0] as? Double,
            let long = coords[1] as? Double,
            
            let props = fDict["properties"] as? [String: AnyObject],
            let name = props["name"] as? String,
            let catValue = props["category"] as? String
            else {
                print("fragmented data, skip")
                return nil
        }
        
        let location = Location(latitude: lat, longitude: long)
        
        if !location.isValid {
            print("invalid coordinates entered for \(name)")
            return nil
        }
        
        // optional
        let description = props["description"] as? String
        let category = PlaceCategory(rawValue: catValue) ?? .misc
        
        self.init(
            title: name,
            description: description,
            location: location,
            category: category
        )
    }
}

extension Set where Element == Place {
    
    func getBoundariesAround() -> MapBoundaries? {
        // set initial values to compare to with first element
        guard let first = first else { return nil }
        var maxLat: Double = first.location.latitude
        var minLat: Double = first.location.latitude
        var maxLong: Double = first.location.longitude
        var minLong: Double = first.location.longitude
        
        // iterate through set and set maxes and mins
        for mapped in self {
            let loc = mapped.location
            
            if loc.latitude > maxLat {
                maxLat = loc.latitude
            }
            
            if loc.latitude < minLat {
                minLat = loc.latitude
            }
            
            if loc.longitude > maxLong {
                maxLong = loc.longitude
            }
            
            if loc.longitude < minLong {
                minLong = loc.longitude
            }
        }
        
        let mrgn: Double = 0.001 // padding on perimeter of points
        
        return MapBoundaries(
            northLat: maxLat + mrgn,
            southLat: minLat - mrgn,
            eastLong: maxLong + mrgn,
            westLong: minLong - mrgn
        )
    }
    
}


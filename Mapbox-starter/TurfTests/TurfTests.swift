//
//  TurfTests.swift
//  TurfTests
//
//  Created by Rob Labs on 9/3/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Turf

class BoundingBoxTests: XCTestCase {
    
    func testPolygon() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 48.714525, longitude: -122.954178),
            CLLocationCoordinate2D(latitude: 48.660129, longitude: -123.026276),
            CLLocationCoordinate2D(latitude: 48.619747, longitude: -123.033829),
            CLLocationCoordinate2D(latitude: 48.604312, longitude: -123.022842),
            CLLocationCoordinate2D(latitude: 48.590688, longitude: -122.923965),
            CLLocationCoordinate2D(latitude: 48.587963, longitude: -122.869721),
            CLLocationCoordinate2D(latitude: 48.602041, longitude: -122.812729),
            CLLocationCoordinate2D(latitude: 48.608398, longitude: -122.782516),
            CLLocationCoordinate2D(latitude: 48.640169, longitude: -122.733765),
            CLLocationCoordinate2D(latitude: 48.660582, longitude: -122.784576),
            CLLocationCoordinate2D(latitude: 48.698212, longitude: -122.886887),
            CLLocationCoordinate2D(latitude: 48.724038, longitude: -122.954178)

        ]
        
        let bbox = BoundingBox(from: coordinates)
        print(bbox!.southWest, bbox!.northEast)
    }
    
    func testCoordinatesOrder() {
        /// Two points:  `southWest`, then `northEast`
        let wsen = [
            CLLocationCoordinate2D(latitude: 31, longitude: -118),
            CLLocationCoordinate2D(latitude: 34, longitude: -113)
        ]
        
        /// Same two points, but a different order:  `northEast` then `southWest`
        let enws = [
            CLLocationCoordinate2D(latitude: 34, longitude: -113),
            CLLocationCoordinate2D(latitude: 31, longitude: -118)
        ]
        
        let swBoundingBox = BoundingBox(from: wsen)
        let enBoundingBox = BoundingBox(from: enws)
        print(swBoundingBox)
        print(enBoundingBox)
        XCTAssertEqual(swBoundingBox?.southWest, enBoundingBox?.southWest)
        XCTAssertEqual(swBoundingBox?.northEast, enBoundingBox?.northEast)
    }
    
}

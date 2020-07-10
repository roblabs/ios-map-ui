//
//  MapKit_starterDirections.swift
//  MapKit-starterUITests
//
//  Created by Rob Labs on 5/22/20.
//  Copyright © 2020 Rob Labs. All rights reserved.
//

import XCTest
import MapKit

class MapKit_starterDirections: XCTestCase, MKMapViewDelegate {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testRoute() throws {
        // 1.  Set source & destination
        let sourceLocation = CLLocationCoordinate2D(latitude: 32.9700, longitude: -117.1307)
        let destinationLocation = CLLocationCoordinate2D(latitude: 33.0045, longitude: -117.1636)
        
        // 2. init MKPlaceMark
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 3. init MKMapItem
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
        }
    }
}

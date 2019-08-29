//
//  LocationManager.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import CoreLocation

// CLLocationManager Singleton

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    private(set) var currentCoordiante: CLLocationCoordinate2D!
    private(set) var currentHeading: CLHeading!
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    var authStatus: CLAuthorizationStatus = .notDetermined {
        didSet {
            // start or stop updating location based on auth status change
            if servicesEnabled { toggleUpdatingLocation() }
            
            // post notification of change for controllers to receive
            NotificationCenter.default.post(
                name: .locationServicesStatusChange, object: nil
            )
        }
    }
    
    var updatingLocation: Bool = false // defaults to not updating
    
    func toggleUpdatingLocation() {
        // check if currently updating location
        // stop if yes, start if not
        if updatingLocation {
            manager.stopUpdatingLocation()
        } else {
            manager.startUpdatingLocation()
        }
        
        // change updatingLocation variable to reflect the previous action
        updatingLocation = !updatingLocation
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        currentCoordiante = loc.coordinate
    }
    
    // delete these 2 delegate methods if heading unnecessary
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeading = newHeading
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    var servicesEnabled: Bool {
        switch authStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined, .denied, .restricted:
            return false
        @unknown default:
            print("added new authorization status, change location manager's delegate method")
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error: \(error.localizedDescription)")
    }
}

extension Notification.Name {
    static let locationServicesStatusChange = Notification.Name("locationServicesStatusChange")
}


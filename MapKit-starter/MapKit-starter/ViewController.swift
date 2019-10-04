//
//  ViewController.swift
//  MapKit-starter
//
//  Created by Rob Labs on 8/11/19.
//  Copyright © 2019 Rob Labs. All rights reserved.
//

import UIKit
import MapKit
import os.signpost

class ViewController: UIViewController {
    
    var oslog = OSLog(subsystem: "roblabs.com.ios-map-ui", category: "ViewController")

    override func viewDidLoad() {
        if #available(iOS 12.0, *) {
            os_signpost(.event, log: oslog, name: "viewDidLoad")
            os_signpost(.begin, log: oslog, name: "viewDidLoad")
        }
        super.viewDidLoad()
        
        let mapView = MKMapView()
        mapView.frame = view.bounds
        mapView.setCenter(CLLocationCoordinate2D(latitude: 32.5, longitude: -116.9), animated: true)
        
        mapView.mapType = MKMapType.mutedStandard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        mapView.center = view.center
        
        view.addSubview(mapView)
        if #available(iOS 12.0, *) {
            os_signpost(.end, log: oslog, name: "viewDidLoad")
        }
    }


}


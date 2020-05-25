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

class ViewController: UIViewController, MKMapViewDelegate {
    
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
        
        mapView.delegate = self
        
        view.addSubview(mapView)
        if #available(iOS 12.0, *) {
            os_signpost(.end, log: oslog, name: "viewDidLoad")
        }
    }
    
    /// - Tag: MKMapViewDelegate
    // Print to console the states as reported by the MKMapViewDelegate
    // Useful to see what state MapKit is in

    // MARK: - Responding to Map Position Changes
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("mapView(_:regionWillChangeAnimated:)")
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print("mapViewDidChangeVisibleRegion(_:)")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("mapView(_:regionDidChangeAnimated:)")
    }
    
    // MARK: - Loading the Map Data
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        print("mapViewWillStartLoadingMap")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("mapViewDidFinishLoadingMap")
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("mapViewDidFailLoadingMap(_:withError:)")
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("mapViewWillStartRenderingMap")
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("mapViewDidFinishRenderingMap \(mapView.camera.description)")
    }
    
    // MARK: - Tracking the User Location

    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("mapViewDidStopLocatingUser")
    }
        
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("mapViewWillStartLocatingUser")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("mapView(_:didUpdate:)")
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        print("mapView(_:didFailToLocateUserWithError:)")
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print("mapView(_:didChange:)")
    }
    
    // MARK: - Managing Annotation Views
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("mapView(_:viewFor:)")
        return MKAnnotationView()
    }
    
//        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//            print("mapView(_:didAdd:)")
//        }

    // MARK: - Dragging an Annotation View
    
    // MARK: - Selecting Annotation Views
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("mapView(_:didSelect:)")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("mapView(_:didDeselect:)")
    }
    
    // MARK: - Managing the Display of Overlays
    
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            print("mapView(_:rendererFor:)")
//            return MKOverlayRenderer()
//        }
    
    func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {
        print("mapView(_:didAdd:)")
    }

}

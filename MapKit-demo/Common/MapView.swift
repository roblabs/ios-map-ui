//
//  MapView.swift
//  MapKit-demo
//
//  Created by Rob Labs on 1/4/20.
//  Copyright © 2020 Rob Labs. All rights reserved.
//

import SwiftUI
import MapKit
import OSLog
import MapViewOSLogExtensions

struct MapView: UIViewRepresentable {
    
    @Binding var mapType: MKMapType
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var centerSpan: MKCoordinateSpan
    
    /// To make sure users do not accidentally pan away from the event and get lost, apply a camera boundary.
    /// This ensures that the center point of the map always remain inside this region.
    ///   A boundary of an area within which the map's center must remain.
    @Binding var cameraBoundary: MKCoordinateRegion
    
    /// Apply a camera zoom range to restrict how far in and out users can zoom in the map view.
    ///   A range that determines the minimum and maximum distance of the camera to the center of the map.
    @Binding var cameraZoomRange: MKMapView.CameraZoomRange

    /// A virtual camera for defining the appearance of the map.
    @Binding var mapCamera: MKMapCamera
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        OSLog.mapView(.event)
        let mapView = MKMapView()
        
        // Accessing Map Properties
        mapView.mapType = mapType
        
        // Manipulating the Visible Portion of the Map
        let region = MKCoordinateRegion(center: centerCoordinate, span: centerSpan)
        mapView.setRegion(region, animated: true)
        
        // Constraining the Map View
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: cameraBoundary)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: cameraZoomRange.minCenterCoordinateDistance,
            maxCenterCoordinateDistance: cameraZoomRange.maxCenterCoordinateDistance)
        mapView.camera = mapCamera
        
        // Configuring the Map’s Appearance
        mapView.showsBuildings = true
        
        #if os(iOS)
            mapView.isPitchEnabled = true
            mapView.isRotateEnabled = true
            mapView.showsCompass = true
        #elseif os(macOS)
            mapView.isPitchEnabled = false
            mapView.isRotateEnabled = false
            mapView.showsCompass = true
            mapView.showsZoomControls = true
        #elseif os(tvOS)
        #endif
        
        // Displaying the User’s Location
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        mapView.delegate = context.coordinator
        
        OSLog.mapView(.event, "🖼 frame: \(mapView.frame)")
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        OSLog.mapView(.event)
        let locationVisible = mapView.isUserLocationVisible
    }
    
    // MARK: - Coordinator
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            OSLog.mapView(.event, OSLog.mapEvents.initDelegate.description)
            self.control = control
        }
        
        /// - Tag: MKMapViewDelegate
        // Print to console the states as reported by the MKMapViewDelegate
        // Useful to see what state MapKit is in

        // MARK: - Responding to Map Position Changes
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            OSLog.mapView(.event, OSLog.mapEvents.regionWillChangeAnimated.description)
        }

        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            OSLog.mapView(.event, OSLog.mapEvents.DidChangeVisibleRegion.description)
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            OSLog.mapView(.event, OSLog.mapEvents.regionDidChangeAnimated.description)
        }
        
        // MARK: - Loading the Map Data
        
        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            OSLog.mapView(.event, OSLog.mapEvents.WillStartLoadingMap.description)
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            OSLog.mapView(.event, OSLog.mapEvents.DidFinishLoadingMap.description)
        }
        
        func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
            OSLog.mapView(.event)
        }
        
        func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
            OSLog.mapView(.event, OSLog.mapEvents.WillStartRenderingMap.description)
        }
        
        func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
            OSLog.mapView(.event, OSLog.mapEvents.DidFinishRenderingMap.description)
            OSLog.mapView(.event, "\(OSLog.mapEvents.DidFinishRenderingMap.description):  \(mapView.camera.description)")
        }
        
        // MARK: - Tracking the User Location

        func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
            OSLog.mapView(.event)
        }
            
        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            OSLog.mapView(.event)
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            OSLog.mapView(.event)
        }
        
        func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
            OSLog.mapView(.event)
        }
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            OSLog.mapView(.event)
        }
        
        // MARK: - Managing Annotation Views
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            OSLog.mapView(.event)
            return MKAnnotationView()
        }
        
//        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//            print("mapView(_:didAdd:)")
//        }

        // MARK: - Dragging an Annotation View
        
        // MARK: - Selecting Annotation Views
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            OSLog.mapView(.event)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            OSLog.mapView(.event)
        }
        
        // MARK: - Managing the Display of Overlays
        
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            print("mapView(_:rendererFor:)")
//            return MKOverlayRenderer()
//        }
        
        func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {
            OSLog.mapView(.event)
        }
    }
}


struct MapView_Previews: PreviewProvider {
    
    // MARK: - MapView() Preview Values
    static let center: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 32.716176,
        longitude: -117.16952)
    static let span: CLLocationDegrees = 10.0
    static let boundaryRange: MKCoordinateRegion = MKCoordinateRegion(
        center: center,
        latitudinalMeters: 1000 * 1000,
        longitudinalMeters: 1000 * 1000)
    static let zoomRange: MKMapView.CameraZoomRange = MKMapView.CameraZoomRange(
        minCenterCoordinateDistance: 0.5 * 1000,
        maxCenterCoordinateDistance: 500.0 * 1000)!
    static let camera = MKMapCamera(
        lookingAtCenter: center,
        fromDistance: 5.0 * 1000,
        pitch: 45.0,
        heading: -90)

    // Manipulating the Visible Portion of the Map
    @State static var mapType = MKMapType.standard
    @State static var centerCoordinate = center
    @State static var centerSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        
    // Camera - Constraining the Map View
    @State static var cameraBoundary = boundaryRange
    @State static var cameraZoomRange = zoomRange
    @State static var mapCamera = camera
    
    static let deviceNames: [String] = [
        "iPhone 11 Pro"
        , "Apple TV"
    ]

    static var previews: some View {
        
        let group = Group {
            ForEach(deviceNames, id: \.self) { deviceName in
                MapView(mapType: $mapType,
                        centerCoordinate: $centerCoordinate,
                        centerSpan: $centerSpan,
                        cameraBoundary: $cameraBoundary,
                        cameraZoomRange: $cameraZoomRange,
                        mapCamera: $mapCamera)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName)")
            }
        }
        
        return group
    }
}

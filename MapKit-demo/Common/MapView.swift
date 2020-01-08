//
//  MapView.swift
//  MapKit-demo
//
//  Created by Rob Labs on 1/4/20.
//  Copyright © 2020 Rob Labs. All rights reserved.
//

import SwiftUI
import MapKit

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
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        let locationVisible = mapView.isUserLocationVisible
        
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

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
    
    var mapType: MKMapType
    var coordinate = CLLocationCoordinate2D(latitude: 33.0, longitude: -117)
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        
        // Accessing Map Properties
        mapView.mapType = mapType
        
        // Manipulating the Visible Portion of the Map
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
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

struct BaseMapView: View {
    var mapType : MKMapType = .standard
    var body: some View {
        return MapView(mapType: mapType)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {

        let deviceNames: [String] = [
            "iPhone 11 Pro",
            "Apple TV"
        ]
        
        let group = Group {
            ForEach(deviceNames, id: \.self) { deviceName in
            MapView(mapType: .standard)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName)")
            }
        }
        
        return group
    }
}

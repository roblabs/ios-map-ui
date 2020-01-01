//
//  ContentView.swift
//  MapKit-SwiftUI-for-iOS-macOS
//
//  Created by Rob Labs on 12/26/19.
//  Copyright © 2019 Rob Labs. All rights reserved.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    
    var mapType: MKMapType
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = mapType
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        let location = CLLocationCoordinate2D(latitude: 33.0,
                                              longitude: -117)
    

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}

struct ContentView: View {
    @State private var mapType : MKMapType = .standard
    var body: some View {
        MapView(mapType: mapType)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        /// Test several MapKit Maps in the SwiftUI Canvas
        Group {
            MapView(mapType: .standard)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("dark extraExtraExtraLarge")
                .environment(\.colorScheme, .dark)
                .environment(\.sizeCategory, .extraExtraExtraLarge)

            MapView(mapType: .standard)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("light extraExtraExtraLarge")
                .environment(\.colorScheme, .light)
                .environment(\.sizeCategory, .extraExtraExtraLarge)

            MapView(mapType: .standard)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("standard extraSmall")
                .environment(\.sizeCategory, .extraSmall)

            MapView(mapType: .hybrid)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("hybrid")

            MapView(mapType: .hybridFlyover)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("hybridFlyover")
            
            MapView(mapType: .satellite)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("satellite")
            
            MapView(mapType: .satelliteFlyover)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("satelliteFlyover")
        }
        
    }
}

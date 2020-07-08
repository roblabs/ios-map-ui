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

/**
  Preview MapKit in multiple devices in SwiftUI
 - Author: Rob Labs
 - Version: 3.14
 - Date: July 2020
 - SeeAlso: [previewDevice](https://developer.apple.com/documentation/swiftui/view/previewdevice(_:))
 - remark: You can look up the `.previewDevice` names by right clicking on `.previewDevice` in Xcode.  As of this writing, here is a list of SwiftUI preview devices.
 
 ---
 
        "iPhone 7"
        "iPhone 7 Plus"
        "iPhone 8"
        "iPhone 8 Plus"
        "iPhone SE"
        "iPhone X"
        "iPhone Xs"
        "iPhone Xs Max"
        "iPhone Xʀ"
        "iPad mini 4"
        "iPad Air 2"
        "iPad Pro (9.7-inch)"
        "iPad Pro (12.9-inch)"
        "iPad (5th generation)"
        "iPad Pro (12.9-inch) (2nd generation)"
        "iPad Pro (10.5-inch)"
        "iPad (6th generation)"
        "iPad Pro (11-inch)"
        "iPad Pro (12.9-inch) (3rd generation)"
        "iPad mini (5th generation)"
        "iPad Air (3rd generation)"
 */
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

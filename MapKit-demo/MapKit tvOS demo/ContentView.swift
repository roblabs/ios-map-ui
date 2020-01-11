//
//  ContentView.swift
//  MapKit tvOS demo
//
//  Created by Rob Labs on 1/4/20.
//  Copyright © 2020 Rob Labs. All rights reserved.
//

import SwiftUI
import MapKit

struct TabItem: Identifiable {
    var id = UUID()
    var image: Image
    var tag: Int
    var title: String
    var type: MKMapType = .standard
}

struct ContentView: View {
    @State private var selection = 0

    // MARK: - DetailView() View initial Values
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
    @State private var mapType = MKMapType.standard
    @State private var centerCoordinate = center
    @State private var centerSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)

    // Camera - Constraining the Map View
    @State private var cameraBoundary = boundaryRange
    @State private var cameraZoomRange = zoomRange
    @State private var mapCamera = camera

    let tabData: [TabItem] = [
        TabItem(image: Image("first"), tag: 0, title: String("standard"), type: .standard),
        TabItem(image: Image("first"), tag: 1, title: String("satellite"), type: .satellite),
        TabItem(image: Image("first"), tag: 2, title: String("hybrid"), type: .hybrid),
        TabItem(image: Image("first"), tag: 3, title: String("satelliteFlyover"), type: .satelliteFlyover),
        TabItem(image: Image("first"), tag: 4, title: String("hybridFlyover"), type: .hybridFlyover),
        TabItem(image: Image("first"), tag: 5, title: String("mutedStandard"), type: .mutedStandard)
    ]
 
    var body: some View {
        return TabView(selection: $selection){
            
            ForEach(tabData.indices) { index in
                MapView(mapType: self.$mapType,
                        centerCoordinate: self.$centerCoordinate,
                        centerSpan: self.$centerSpan,
                        cameraBoundary: self.$cameraBoundary,
                        cameraZoomRange: self.$cameraZoomRange,
                        mapCamera: self.$mapCamera)
                    .font(.title)
                    .tabItem {
                        HStack {
                            Image("first")
                            Text(self.tabData[index].title + " \(index)")
                        }
                    }
                .tag(self.tabData[index].tag)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let deviceNames: [String] = [
            "Apple TV",
            "Apple TV 4K"
        ]
        
        let group = Group {
            ForEach(deviceNames, id: \.self) { deviceName in
            ContentView()
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName("\(deviceName)")
            }
        }
        
        return group
    }
}

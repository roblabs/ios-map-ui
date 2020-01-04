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
        mapView.mapType = mapType
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {

        let deviceNames: [String] = [
            "iPhone SE",
            "iPhone 11 Pro Max",
            "iPad Pro (11-inch)"
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

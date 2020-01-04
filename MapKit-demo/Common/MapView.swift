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
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>) {

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
            MapView(mapType: .standard)
    }
}

//
//  ContentView.swift
//  MapKit-SwiftUI-for-tvOS
//
//  Created by Rob Labs on 12/29/19.
//  Copyright © 2019 Rob Labs. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        let location = CLLocationCoordinate2D(latitude: 32.7156, longitude: -117.1647)
        let span = MKCoordinateSpan(latitudeDelta : 1,
                                    longitudeDelta: 1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.region = region
        
//        if #available(iOS 9, macOS 10.15, *) {
//            mapView.isPitchEnabled = true
//        } else {
//            mapView.isRotateEnabled = true
//        }
        
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    // MARK: - Coordinator
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
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
            print("mapViewDidFinishRenderingMap")
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
}


// MARK: - ContentView
struct ContentView: View {
    var body: some View {
        ZStack {
            MapView()
                .edgesIgnoringSafeArea( .all)
        }
    }
}

// MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "Apple TV"))
                .previewDisplayName("Apple TV Dark")
                .environment(\.colorScheme, .dark)
                .environment(\.sizeCategory, .extraExtraExtraLarge)

            ContentView()
                .previewDevice(PreviewDevice(rawValue: "Apple TV"))
                .previewDisplayName("Apple TV Light")
                .environment(\.colorScheme, .light)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}

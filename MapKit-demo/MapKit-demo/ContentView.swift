//
//  ContentView.swift
//  MapKit-demo
//
//  Created by Rob Labs on 1/4/20.
//  Copyright © 2020 Rob Labs. All rights reserved.
//

import SwiftUI
import MapKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @State private var dates = [Date]()

    var body: some View {
        NavigationView {
            MasterView(dates: $dates)
                .navigationBarTitle(Text("Master"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { self.dates.insert(Date(), at: 0) }
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                )
            DetailView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Binding var dates: [Date]

    var body: some View {
        List {
            ForEach(dates, id: \.self) { date in
                NavigationLink(
                    destination: DetailView(selectedDate: date)
                ) {
                    Text("\(date, formatter: dateFormatter)")
                }
            }.onDelete { indices in
                indices.forEach { self.dates.remove(at: $0) }
            }
        }
    }
}

struct DetailView: View {
    var selectedDate: Date?
    
    static let center: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 32.716176,
        longitude: -117.16952)
    static let span: CLLocationDegrees = 10.0
    static let boundaryRange: MKCoordinateRegion = MKCoordinateRegion(
        center: center,
        latitudinalMeters: 1 * 1000,
        longitudinalMeters: 1 * 1000)
    static let zoomRange: MKMapView.CameraZoomRange = MKMapView.CameraZoomRange(
        minCenterCoordinateDistance: 0.5 * 1000,
        maxCenterCoordinateDistance: 5.0 * 1000)!

    // Manipulating the Visible Portion of the Map
    @State static var mapType = MKMapType.hybrid
    @State static var centerCoordinate = center
    @State static var centerSpan = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        
    // Camera - Constraining the Map View
    @State static var cameraBoundary = boundaryRange
    @State static var cameraZoomRange = zoomRange

    var body: some View {
        Group {
            MapView(mapType: DetailView.$mapType,
                    centerCoordinate: DetailView.$centerCoordinate,
                    centerSpan: DetailView.$centerSpan,
                    cameraBoundary: DetailView.$cameraBoundary,
                    cameraZoomRange: DetailView.$cameraZoomRange)
            if selectedDate != nil {
                Text("\(selectedDate!, formatter: dateFormatter)")
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

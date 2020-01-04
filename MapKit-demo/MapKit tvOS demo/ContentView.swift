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
    
    let tabData = [
        TabItem(image: Image("first"), tag: 0, title: String("standard"), type: .standard),
        TabItem(image: Image("first"), tag: 1, title: String("satellite"), type: .satellite),
        TabItem(image: Image("first"), tag: 2, title: String("hybrid"), type: .hybrid),
        TabItem(image: Image("first"), tag: 3, title: String("satelliteFlyover"), type: .satelliteFlyover),
        TabItem(image: Image("first"), tag: 4, title: String("hybridFlyover"), type: .hybridFlyover),
        TabItem(image: Image("first"), tag: 5, title: String("mutedStandard"), type: .mutedStandard)
    ]
 
    var body: some View {
        return TabView(selection: $selection){
            
            ForEach(tabData) { tabItem in
                MapView(mapType: tabItem.type)
                    .font(.title)
                    .tabItem {
                        HStack {
                            Image("first")
                            Text(tabItem.title)
                        }
                    }
                    .tag(tabItem.tag)
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

//
//  ContentView.swift
//  MapKit tvOS demo
//
//  Created by Rob Labs on 1/4/20.
//  Copyright © 2020 Rob Labs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
                MapView(mapType: .hybridFlyover)
                    .font(.title)
                    .tabItem {
                        HStack {
                            Image("first")
                            Text("First")
                        }
                    }
                    .tag(0)
            MapView(mapType: .standard)
                .font(.title)
                .tabItem {
                    HStack {
                        Image("second")
                        Text("Second")
                    }
                }
                .tag(1)
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

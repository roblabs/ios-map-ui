//
//  SearchPanelControllerSwiftUI.swift
//  Mapbox-starter
//
//  Created by Rob Labs on 7/3/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import SwiftUI

struct SearchPanelControllerPreview: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SearchPanelController
    
    func makeUIViewController(context: Context) -> SettingsPanelController {
        let vc = SearchPanelController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SearchPanelController, context: Context) {
    }
}

struct ContentView_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        SearchPanelControllerPreview()
    }
}

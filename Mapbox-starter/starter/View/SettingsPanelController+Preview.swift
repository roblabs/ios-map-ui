//
//  SettingsPanelController+Preview.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 7/10/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import SwiftUI

struct SettingsPanelControllerPreview: UIViewControllerRepresentable {
    typealias UIViewControllerType = SettingsPanelController
    
    func makeUIViewController(context: Context) -> SettingsPanelController {
        SettingsPanelController()
    }
    
    func updateUIViewController(_ uiViewController: SettingsPanelController, context: Context) {
        //
    }
}

struct ContentView_SettingsPanelControllerPreview: PreviewProvider {
    @available (iOS 13.0.0, *)
    static var previews: some View {
        SettingsPanelControllerPreview()
    }
}

//
//  SettingsPanelControllerPreview.swift
//  Mapbox-starter
//
//  Created by Rob Labs on 7/3/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import SwiftUI

/// - Tag: SettingsPanelControllerPreview_SwiftUI
struct SettingsPanelControllerPreview: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SettingsPanelController
    
    func makeUIViewController(context: Context) -> SettingsPanelController {
        let vc = SettingsPanelController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SettingsPanelController, context: Context) {
        uiViewController.updateSettingsCollection(forState: .collection)
    }
}

struct ContentView_SettingsPanelControllerPreview: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        SettingsPanelControllerPreview()
    }
}

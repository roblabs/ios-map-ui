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
    
    private let state: SettingsPanelController.SettingCollectionViewState = .collection // update to preview different view states
    
    func makeUIViewController(context: Context) -> SettingsPanelController {
        SettingsPanelController()
    }
    
    func updateUIViewController(_ uiViewController: SettingsPanelController, context: Context) {
        uiViewController.updateSettingsCollection(forState: state)
    }
}

struct ContentView_SettingsPanelControllerPreview: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        SettingsPanelControllerPreview()
    }
}

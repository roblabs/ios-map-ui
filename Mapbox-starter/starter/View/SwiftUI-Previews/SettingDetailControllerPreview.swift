//
//  SettingDetailControllerPreview.swift
//  Mapbox-starter
//
//  Created by Rob Labs on 7/17/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import SwiftUI

struct SettingDetailControllerPreview: UIViewControllerRepresentable {

    typealias UIViewControllerType = SettingDetailController

    func makeUIViewController(context: Context) -> SettingDetailController {
        SettingDetailController(setting: Setting.init(id: "id", title: "how cool", subtitle: "is this", imageTitle: "GPS_icon") )
    }

    func updateUIViewController(_ uiViewController: SettingDetailController,
                                context: Context) {
    }
}

/// - Tag: SettingDetailControllerPreview
struct ContentView_SettingDetailControllerPreview: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        SettingDetailControllerPreview()
            .previewLayout(.fixed(width: 568, height: 320)) // iPhone SE landscape
    }
}

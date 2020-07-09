//
//  SettingsCollectionController.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 7/9/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import UIKit

class SettingCollectionController : UIViewController {
    private struct Color {
        static let bg = UIColor.lightText
        static let container = UIColor.lightText
        static let font = UIColor.black
        static let buttonFont = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.container
    }
}

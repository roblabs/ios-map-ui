//
//  Setting.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 7/9/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import Foundation

struct Setting {
    var id = ""
    var title = ""
    var subtitle = ""
    var imageTitle = ""
}

extension Setting: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Setting {
    func setOfflineEnabled(to nv: Bool) {
        UserDefaults.standard.set(nv, forKey: id)
    }
    
    var offlineEnabled: Bool {
        UserDefaults.standard.value(forKey: id) as? Bool ?? false
    }
}

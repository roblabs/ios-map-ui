//
//  MapError.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

enum MapError: String, Error {
    case noAccessToken = "There was no mapbox access token found, please enter it and try again."
    case locationServicesDisabled = "Location Services on this device are disabled. Please enable them and try again."
}

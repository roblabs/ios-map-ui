//
//  SerializationError.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

enum SerializationError: String, Error {
    case fileNotFound = "File not found"
    case parsingError = "Parsing error"
    case formatError = "Data format error"
    case noData = "No Data found"
    case noFeatures = "No Feature Data found"
}

//
//  MapStyle.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

struct MapStyle: Equatable {
    let title: String
    let urlString: String
    
    var url: URL? { return URL(string: self.urlString) }
    
    enum CodingKeys: String, CodingKey {
        case title, urlString
    }
}

// current encoding/decoding process for map styles: by title and url
extension MapStyle: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        urlString = try values.decode(String.self, forKey: .urlString)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(urlString, forKey: .urlString)
    }
}

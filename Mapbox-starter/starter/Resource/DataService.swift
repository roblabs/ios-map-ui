//
//  DataService.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation

struct DataService {
    
    static func fetchData(of file: File) throws -> Map {
        guard let path = Bundle.main.path(forResource: file.name, ofType: file.type)
            else { throw SerializationError.fileNotFound }
        
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        
        return try read(json: json)
    }
    
    private static func read(json: Any) throws -> Map {
        guard let result = json as? [String: AnyObject] else {
            throw SerializationError.formatError
        }
        
        guard
            let title = result["type"] as? String,
            let featureArray = result["features"] as? NSArray
            else {
                throw SerializationError.noData
        }
        
        // get place objects from data
        let mapped = try fetchMappedPlaces(from: featureArray)
        
        // this gets map boundaries from the places found
        // If you have specific boundaries you'd like to load, replace this line below
        let bounds = mapped.getBoundariesAround()!
        
        let map = Map(boundaries: bounds)
        map.title = title
        map.mappedPlaces = mapped
        
        return map
    }
    
    private static func fetchMappedPlaces(from array: NSArray) throws -> Set<Place> {
        var places = Set<Place>()
        
        for feature in array {
            guard let dict = feature as? [String: AnyObject]
                else { continue }
            
            if let mapped = Place(from: dict) {
                places.insert(mapped)
            }
        }
        
        guard !places.isEmpty else { throw SerializationError.noFeatures }
        
        return places
    }
    
}

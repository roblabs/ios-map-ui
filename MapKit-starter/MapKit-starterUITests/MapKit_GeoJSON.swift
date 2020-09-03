//
//  MapKit_GeoJSON.swift
//  MapKit-starterUITests
//
//  Created by Rob Labs on 5/23/20.
//  Copyright © 2020 Rob Labs. All rights reserved.
//

import XCTest
import MapKit

class MapKit_GeoJSON: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    ///  # Using a JSONDecoder() sample from
    ///  [Apple](https://developer.apple.com/documentation/foundation/jsondecoder)
    ///  Parse a `GroceryProduct` object from
    ///   * JSON
    ///   * GeoJSON
    struct GroceryProduct: Codable {
        var name: String
        var points: Int
        var description: String
        var optionalPropertyNotInGeoJSON: String?  /// Use `?` to indicate an optional property key
    }

    struct GeoJSON: Codable {
        var type: String
        var features: [Features]
    }

    struct Features: Codable {
        var type: String
        var properties: Property
        var geometry: Geometry
    }
    
    struct Geometry: Codable {
        var type: String
        var coordinates: [Double]
    }
    
    struct Property: Codable {
        var description: String
        var name: String
        var points: Int
    }

    func testJSONDecoder() {
        let json = """
        {
            "name": "Durian",
            "points": 600,
            "description": "A fruit with a distinctive scent."
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let product = try! decoder.decode(GroceryProduct.self, from: json)

        print(product.name) // Prints "Durian"
    }

    /// Decode GeoJSON with each of these two methods
    /// * `JSONDecoder()`
    ///   * Requires: the following structs: `GeoJSON`, `Features`, `Geometry`, `Property`
    /// * `MKGeoJSONDecoder()`
    ///   * Way easier, but requires iOS 13
    func testGeoJSONDecoder() {
        let geojson = """
        {
          "type": "FeatureCollection",
          "features": [
            {"type": "Feature", "geometry": { "type": "Point", "coordinates": [0, 0] },
               "properties": {"name": "Strawberry", "points": 600, "description": "🍓"} },
            {"type": "Feature", "geometry": { "type": "Point", "coordinates": [1, 1] },
               "properties": {"name": "Apples", "points": 100, "description": "🍎"} },
            {"type": "Feature", "geometry": { "type": "Point", "coordinates": [2, 2] },
               "properties": {"name": "Kale", "points": 2000, "description": "🥬"} },
            {"type": "Feature", "geometry": { "type": "Point", "coordinates": [3, 3] },
               "properties": {"name": "Carrots", "points": 3000, "description": "🥕"} }
          ]
        }
        """.data(using: .utf8)!

        /// Decode with `JSONDecoder`
        /// * Required if you have GeoJSON, but your API is less than iOS 13 (where `MKGeoJSONDecoder` was introduced)
        /// * Or if you cannot use MapKit at all, say if your are using Mapbox
        let jsonFromGeoJSON = try! JSONDecoder().decode(GeoJSON.self, from: geojson)
        for feature in jsonFromGeoJSON.features  {
            let properties = feature.properties
            let name = feature.properties.name
            print(properties.name, properties.description, properties.points)
        }
        
        /// Decode with `MKGeoJSONDecoder`
        let features = try! MKGeoJSONDecoder().decode(geojson)
        var descriptions = [String]()
        var names = [String]()
        
        for element in features {
            let feature = element as! MKGeoJSONFeature
            let properties = try! JSONDecoder().decode(GroceryProduct.self,
                                                       from: feature.properties!)
            
            descriptions.append(properties.description)
            names.append(properties.name)
            print(properties)
        }
        
        print(names)
        print(descriptions)
    }
    
    func testGeoJSONFromVariable() throws {
        
        let geojson = """
        {
          "type": "FeatureCollection",
          "features": [
            { "type": "Feature", "id": "a1",
              "properties": { "data": 1 },
              "geometry": {"type": "Point",
                "coordinates": [-116.12345, 32.6789]}
            },
            {"type": "Feature", "id": "b2",
              "properties": { "data": 2 },
              "geometry": { "type": "LineString",
                "coordinates": [ [0, 0], [1, 1] ] }
            },
            {"type": "Feature", "id": "c3",
              "properties": { "data": 3 },
              "geometry": {"type": "Polygon",
                "coordinates": [[ [0,1], [3,1], [3,2], [0,2], [0,1]] ]
              }
            },
            {"type": "Feature", "id": "d4",
              "properties": { "data": 4 },
              "geometry": { "type": "MultiPoint",
                "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
              }
            },
            {"type": "Feature", "id": "e5",
              "properties": { "data": 5 },
              "geometry": { "type": "MultiLineString",
                "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ]  ]
              }
            },
            {"type": "Feature", "id": "e6",
              "properties": { "data": 6 },
              "geometry": { "type": "MultiPolygon",
                "coordinates": [ [ [ [102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0] ] ],
                                 [ [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
                                 [ [100.2, 0.2], [100.2, 0.8], [100.8, 0.8], [100.8, 0.2], [100.2, 0.2] ] ] ]
              }
            }
          ]
        }
        """
        
        let geojsonData = geojson.data(using: .utf8)!
        let geojsonObjects = try MKGeoJSONDecoder().decode(geojsonData)

        parse(geojsonObjects)
    }
    
    func testGeoJSONFromRemote() {
        
        let urlString = "https://raw.githubusercontent.com/mapbox/csv2geojson/gh-pages/test/data/simple.geojson"
        
        if let url = URL(string: urlString) {
            if let geojsonData = try? Data(contentsOf: url) {
                let geojsonObjects = try? MKGeoJSONDecoder().decode(geojsonData)
                parse(geojsonObjects!)
            }
        }
    }

    func testGeoJSONFromLocal() {

        let bundle = Bundle(for: type(of: self))

        // path approach
        let filePath = bundle.path(forResource: "simple", ofType: "geojson")
        let fileUrl = URL(fileURLWithPath: filePath!)

        let geojsonData = try? Data(contentsOf: fileUrl)
        let geojsonObjects = try? MKGeoJSONDecoder().decode(geojsonData!)
        parse(geojsonObjects!)
        
    }
    
    func testSearchFolderForGeoJSON () {
        let fm = FileManager.default
        let bundle = Bundle(for: type(of: self))
        let path = bundle.bundlePath
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(item)")
                if item.hasSuffix("geojson") {
                    print("//    Found GeoJSON \(item)")
                }
            }
        } catch {
            // failed to read directory
        }
    }

    private func parse(_ jsonObjects: [MKGeoJSONObject]) {
        for object in jsonObjects {

            if let feature = object as? MKGeoJSONFeature {
                
                if let dictionary = try? JSONDecoder().decode([String: Int].self, from: feature.properties!) {
                    print( "data: \(dictionary["data"]), feature: \(feature.identifier)")
                }

                for geometry in feature.geometry {
                    
                    switch geometry {
                        case geometry as? MKPointAnnotation:
                            let geo = geometry as? MKPointAnnotation
                            print("Point = \(geo?.coordinate)")
                        
                        case geometry as? MKPolyline:
                            let geo = geometry as? MKPolyline
                            print("LineString = \(geo?.coordinate), \(geo?.boundingMapRect)" )

                        case geometry as? MKPolygon:
                            let geo = geometry as? MKPolygon
                            print("Polygon = \(geo?.coordinate) \(geo?.boundingMapRect), \(geo?.interiorPolygons)" )

                        case geometry as? MKMultiPoint:
                            let geo = geometry as? MKMultiPoint
                            print("MultiPoint = \(geo?.points()) pointCount = \(geo?.pointCount)" )

                        case geometry as? MKMultiPolyline:
                            let geo = geometry as? MKMultiPolyline
                            print("MultiLineString = \(geo?.coordinate) \(geo?.boundingMapRect), \(geo?.polylines)" )
                        
                        case geometry as? MKMultiPolygon:
                            let geo = geometry as? MKMultiPolygon
                            print("MultiPolygon = \(geo?.coordinate), \(geo?.boundingMapRect), \(geo?.polygons)")
                        
                        default:
                            print("geometry type not dealt with")
                        }
                }
            }
        }
    }

}

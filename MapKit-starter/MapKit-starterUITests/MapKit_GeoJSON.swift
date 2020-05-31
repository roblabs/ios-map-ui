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
    
    ///
    ///  # Using a JSONDecoder() sample from [Apple](https://developer.apple.com/documentation/foundation/jsondecoder)
    ///  Parse a `GroceryProduct` object from
    ///   * JSON
    ///   * GeoJSON
    ///
    struct GroceryProduct: Codable {
        var name: String
        var points: Int
        var description: String
        var optionalPropertyNotInGeoJSON: String?  /// Use `?` to indicate an optional property key
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

    func testGeoJSONDecoder() {
        let geojson = """
        {
          "type": "FeatureCollection",
          "features": [
            {
              "type": "Feature",
              "properties": {
                "name": "Durian",
                "points": 600,
                "description": "A fruit with a distinctive scent."
              },
              "geometry": { "type": "Point", "coordinates": [0,0] }
            }
          ]
        }
        """.data(using: .utf8)!

        let geojsonObjects = try! MKGeoJSONDecoder().decode(
            geojson)
        
        let feature = geojsonObjects[0] as! MKGeoJSONFeature
        let properties = try! JSONDecoder().decode(
            GroceryProduct.self, from: feature.properties!)

        print(properties.name) // Prints "Durian"
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

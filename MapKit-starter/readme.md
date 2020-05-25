# MapKit Starter

Starter project for creating MapKit without storyboards.

## XCTest

MapKit Starter also includes UI Test & Unit Test cases for

* Starting MapKit in a different language using `launchArguments`
* Directions and routing in MapKit using [`MKDirections`](https://developer.apple.com/documentation/mapkit/mkdirections)
* Parsing GeoJSON using [`MKGeoJSONDecoder`](https://developer.apple.com/documentation/mapkit/mkgeojsondecoder)
  * Parsing GeoJSON from:
    * A Swift varible:  `let geojson = """...`
    * A GeoJSON local to the app: `simple.geojson`
    * A GeoJSON from a web server:  `RobLabs. com/simple.geojson`
  * Geometry object examples include parsing `Point`, `MultiPoint`, `LineString`, `MultiLineString`, `Polygon`, `MultiPolygon`
  * See the GeoJSON standards specification [RFC 7946](https://tools.ietf.org/html/rfc7946#section-3.1) for more information about Feature objects.

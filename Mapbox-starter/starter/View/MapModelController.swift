//
//  MapModelController.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import UIKit
import Mapbox
import Turf

private let currentFile = File(name: "points", type: "geojson")

class MapModelController: UIViewController {
    
    // MARK: Model objects
    
    var model: MapViewModel?
    private let locationManager = LocationManager.shared
    
    /// test list of Islands from `grids.geojson`
    let sanJuanIslands = ["Orcas", "Jones", "Sucia", "Matia", "Stuart", "Johns"] // main list, TODO:  this should be parsed from the GeoJSON

    struct Grids {
        /// id for the grids `layer`  in the Mapbox Style
        let layerIdentifier = "grids-layer"
        
        /// id for the grids `source` in the Mapbox Style
        let sourceIdentifier = "grids-source"
        
        /// This name MUST exist in the Grids GeoJSON `properties`
        let gridPropertiesKey = "name"
        
        /// Array of `name`'s to keep track of which grid was selected
        var names = [String]()
        
        /// Array of bounding boxes to keep track of which grid was selected
        var coordinates = [MGLCoordinateBounds]()
    }
    
    var grids = Grids()

    /// Progress for offline maps
    var progressView: UIProgressView!
    
    private lazy var mapView: MGLMapView! = {
        let mapView = MGLMapView(frame: view.bounds, styleURL: Default.style.url)
        mapView.delegate = self
        mapView.compassView.compassVisibility = .visible
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let center = model?.map.boundaries.center.clCoord ?? Default.center
        mapView.setCenter(CLLocationCoordinate2D(latitude: 32, longitude: -116), zoomLevel: 12, animated: false)
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = true
        view.addSubview(mapView)
        return mapView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.topRightContainer
        view.layer.cornerRadius = Default.cornerRadius / 2
        view.clipsToBounds = true
        view.activateAnchors(for: topRightContainerSize)
        self.view.addSubview(view)
        return view
    }()
    
    // MARK: - Details & GPS Buttons
    private lazy var detailsButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(detailsTapped), for: .touchUpInside)
        button.activateAnchors(for: topRightButtonSize)
        containerView.addSubview(button)
        return button
    }()
    
    private lazy var gpsButton: GPSButton = {
        let button = GPSButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.activateAnchors(for: topRightButtonSize)
        button.addTarget(self, action: #selector(gpsTapped), for: .touchUpInside)
        containerView.addSubview(button)
        return button
    }()
    
    // MARK: View methods
    
    override func viewDidLoad() {
        LogManager.signpostEvent(event: .mapModelController(.viewDidLoad))
        LogManager.signpostBegin(event: .mapModelController(.viewDidLoad))
        super.viewDidLoad()
        loadModel()
        loadSubViews()
        LogManager.signpostEnd(event: .mapModelController(.viewDidLoad))
        
        /// Offline maps
        // Setup offline pack notification handlers.
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
        
        #if DEBUG
        var mask = [] as MGLMapDebugMaskOptions
        mask = [ MGLMapDebugMaskOptions.tileBoundariesMask, MGLMapDebugMaskOptions.tileInfoMask]

        mapView.debugMask = mask
        #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCompass()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func loadModel() {
        // load data model
        do {
            model = try MapViewModel()
        } catch let error {
            handle(error: error)
        }
        
        // load annotations from data
        guard model != nil else { return }
        mapView.addAnnotations(model!.annotations)
        mapView.showAnnotations(mapView.annotations!, animated: false)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 48.5, longitude: -122.98), zoomLevel: 9, animated: false)
        
        // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
    }
    
    private func loadSubViews() {
        NSLayoutConstraint.activate(viewConstraints)
        
        // notify GPS Button when new location services determined
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locServicesStatusChanged),
            name: .locationServicesStatusChange,
            object: nil
        )
    }
    
    // configure compassView position based on button containerView
    private func configureCompass() {
        let compass = mapView.compassView
        
        let compassH = compass.bounds.height
        let offset = Default.padding // how far below containerView compass sits
        let centerY = containerView.frame.maxY + offset + compassH / 2
        let centerX = containerView.center.x
        
        compass.center = CGPoint(x: centerX, y: centerY)
    }
    
    // MARK: Action methods
    
    @objc func locServicesStatusChanged() {
        // location services permission determined
        // locMngr starts updating if auth status ok'd
        // set initial gpsButton appearance based on if updating location
        gpsButton.isSelected = locationManager.updatingLocation
    }
    
    @objc func detailsTapped() {
//        panelState = .settings
        toggleLayer("layer-osm")
//        updateRasterSource()
    }
    
    @objc func gpsTapped() {
        do {
            try toggleLocationUpdates()
        } catch let error {
            // restore button to normal if unable to track location
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.gpsButton.isSelected = false
            }
            
            handle(error: error)
        }
    }
    
    private func toggleLocationUpdates() throws {
        guard locationManager.servicesEnabled else {
            throw MapError.locationServicesDisabled
        }
        
        locationManager.toggleUpdatingLocation()
    }
    // MARK: Errors
    
    private func handle(error: Error) {
        switch error {
        case let sError as SerializationError:
            showAlert(title: "Error Loading Map Info", message: sError.rawValue)
        case let mapError as MapError:
            showAlert(message: mapError.rawValue)
        default:
            print("some other error: \(error.localizedDescription)")
        }
    }
}

// MARK: - extension MGLMapViewDelegate
extension MapModelController: MGLMapViewDelegate {
    private var annoReuseId: String { return "annoReuseId" }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // reuse annotationView if there
        if let annoView = mapView.dequeueReusableAnnotationView(withIdentifier: annoReuseId) {
            return annoView
        }
        
        // initialize new place annotationView with lack of previous
        guard let pAnno = annotation as? PlaceAnnotation else {
            return nil // don't init if not placeAnnotation
        }
        
        return PlaceAnnotationView(placeAnnotation: pAnno, reuseIdentifier: annoReuseId)
    }
    
    /**
     Tells the delegate that the map view was unable to load data needed for displaying the map.

     This method may be called for a variety of reasons, including a network connection failure or a failure to fetch the style from the server. You can use the given error message to notify the user that map data is unavailable.
     */
    func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error) {
        #if DEBUG
        fatalError("-mapViewDidFailLoadingMap:withError: \(error)")
        #endif
    }
    
    /**
     Tells the delegate that the map view will begin to load.

     This method is called whenever the map view starts loading, including when a new style has been set and the map must reload.
     */
    func mapViewWillStartLoadingMap(_ mapView: MGLMapView) {
        #if DEBUG
        print("-mapViewWillStartLoadingMap:")
        #endif
    }
    
    func mapViewWillStartRenderingMap(_ mapView: MGLMapView) {
        #if DEBUG
        print("-mapViewWillStartRenderingMap:")
        #endif
    }
    
    /**
     Tells the delegate that the map view is entering an idle state, and no more drawing will be necessary until new data is loaded or there is some interaction with the map.

     * No camera transitions are in progress
     * All currently requested tiles have loaded
     * All fade/transition animations have completed
     */
    func mapViewDidBecomeIdle(_ mapView: MGLMapView) {
        #if DEBUG
        print("-mapViewDidBecomeIdle:")
        #endif
    }
    
    /// Print out metadata from the current map view, useful testing of regions & centers for Offline maps
    ///   # Debugger (lldb) #
    /**
```
# print out the Sources & Layers for inspection
# The layers included in the style, arranged according to their back-to-front ordering on the screen.
po mapView.style?.layers

# A set containing the style’s sources.
po mapView.style?.sources
```
     */
    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        #if DEBUG
        /// Convenience pretty printing:  go straight from the log to code
        let latitude = String(format: "%.6f", mapView.latitude)
        let longitude = String(format: "%.6f", mapView.longitude)
        let zoomLevel = String(format: "%.2f", mapView.zoomLevel)
        let visibleCoordinateBounds = mapView.visibleCoordinateBounds
        print("mapView.styleURL = \(String(describing: mapView.styleURL))")
        print("/// `-mapView:regionDidChangeAnimated:`")
        /// use for setting center
        print("mapView.setCenter(CLLocationCoordinate2D(latitude: \(latitude), longitude: \(longitude)), zoomLevel: \(zoomLevel), animated: false)")
        /// use for bounding box and zoom range for Offline testing
        print("let sw = \(visibleCoordinateBounds.sw) ")
        print("let ne = \(visibleCoordinateBounds.ne)")
        print("let fromZoomLevel = 0.0")
        print("let toZoomLevel = \(zoomLevel)")
        #endif
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    // animate compass to show and hide based on map rotation
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        // detect if compass rotated,
        // if compass at 0 degrees, hide
        let compass = mapView.compassView
        let radians = atan2(compass.transform.b, compass.transform.a)
        let degrees = radians * CGFloat(180 / Double.pi)
        
        UIView.animate(withDuration: Default.animationDuration) {
            compass.alpha = degrees == 0 ? 0 : 1
        }
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        loadGeoJson()
    }
    
    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        // Get the CGPoint where the user tapped.
        let spot = sender.location(in: mapView)

        guard let layer = mapView.style?.layer(withIdentifier: grids.layerIdentifier) as? MGLFillStyleLayer else {
            fatalError("Could not cast to specified MGLFillStyleLayer")
        }

        // Access the features at that point within the state layer.
        let features = mapView.visibleFeatures(at: spot, styleLayerIdentifiers: Set([grids.layerIdentifier]))

        // Get the name of the selected state.
        if let feature = features.first, let gridValue = feature.attribute(forKey: grids.gridPropertiesKey) as? String {

            // if gridValue is already on the gridList, then remove it, and change the fillColor back to default
            // If it's not on the gridList, then add it and change the fillColor to show it was selected.
            if let index = grids.names.firstIndex(of: gridValue) {
                grids.names.remove(at: index)
            } else {
                grids.names.append(gridValue)
            }
            
        }
        
        grids.coordinates = []  // reset array and compute bounding box
        gridcomputeBoundingBox()
        gridStartOfflineDownload()
    }
}

// MARK: - extension Offline Maps
extension MapModelController {
    
    /// Start Offline download
    ///
    /// - Parameter boundingBox: The Mapbox Style layer `identifier`.
    /// - Parameter offlineName: Friendly name to save Offline Pack.
    /// - Parameter fromZoomLevel: `zoom` range, minimum.
    /// - Parameter toZoomLevel: `zoom` range, maximum.
    ///
    /// Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
    /// Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
    func startOfflinePackDownload(boundingBox: MGLCoordinateBounds,
                                  offlineName: String = "Offline Maps for Mobile",
                                  fromZoomLevel: Double = 9.0,
                                  toZoomLevel: Double = 14.0) {
        
        let bounds = MGLCoordinateBounds(sw: boundingBox.sw, ne: boundingBox.ne)
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL,
                                                 bounds: bounds,
                                                 fromZoomLevel: fromZoomLevel,
                                                 toZoomLevel: toZoomLevel)

        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": offlineName]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)

        // Create and register an offline pack with the shared offline storage object.

        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            // Start downloading.
            pack!.resume()
        }

    }

    @objc func offlinePackProgressDidChange(notification: NSNotification) {
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected

            // Calculate current progress percentage.
            let progressPercentage = Float(completedResources) / Float(expectedResources)

            // Setup the progress bar.
            if progressView == nil {
                progressView = UIProgressView(progressViewStyle: .default)
                let frame = view.bounds.size
                progressView.frame = CGRect(x: frame.width / 4,
                                            y: frame.height * 0.1,
                                            width: frame.width / 2,
                                            height: 10)
                view.addSubview(progressView)
            }

            progressView.progress = progressPercentage

            // If this pack has finished, print its size and resource count.
            if completedResources == expectedResources {
                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
                print("Offline pack “\(userInfo["name"] ?? "unknown")” completed: \(byteCount), \(completedResources) resources")
            } else {
                // Otherwise, print download/verification progress.
                print("Offline pack “\(userInfo["name"] ?? "unknown")” has \(completedResources) of \(expectedResources) resources — \(String(format: "%.2f", progressPercentage * 100))%.")
            }
        }
    }

    @objc func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” received error: \(error.localizedFailureReason ?? "unknown error")")
        }
    }

    @objc func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” reached limit of \(maximumCount) tiles.")
        }
    }
}

// MARK: - extension Tile Grid UI
extension MapModelController {
    
    /// - TAG: tagtoggleLayer
    /// `toggleLayer` — Turn Mapbox Style layers on and off.
    /// - Parameter layer: The Mapbox Style layer `identifier`.
    ///
    /// Pass in the Mapbox Style layer `identifier`, then toggle the layer between either `visible` or `none`.
    ///  * Mapbox Style Spec — [visibility layout property](https://docs.mapbox.com/mapbox-gl-js/style-spec/layers/#layout-raster-visibility)
    ///  * Maps SDK for iOS — [Managing Style Layers](https://docs.mapbox.com/ios/api/maps/5.9.0/Classes/MGLStyle.html#/c:objc(cs)MGLStyle(im)layerWithIdentifier:)
    ///   # Example Swift usage #
    /**
```
toggleLayer("national-park")
```

     */
    ///   # LLDB Debugger #
    /**
```
# print out the layers array to inspect the layer identifiers

po mapView.style?.layers
```
     */
    func toggleLayer(_ layer: String) {

        let layerVisibility = mapView.style?.layer(withIdentifier: layer)?.isVisible
        let toggle = layerVisibility == false ? true : false
        
        mapView.style?.layer(withIdentifier: layer)?.isVisible = toggle

        #if DEBUG
        print()
        print("Style    \(String(describing: mapView.style?.name!))")
        print("styleURL \(mapView.styleURL!)")
        print("source   \(String(describing: mapView.style?.source(withIdentifier: layer)))")
        print("id:      \(layer)")
        let visibilityDescription = layerVisibility == true ? "visible" : "none"
        print("         layout.visibility: \(visibilityDescription)")
        #endif
    }
    
    /// - TAG: tagupdateRasterSource
    /// `updateRasterSource` — Updates Raster sources in the Mapbox Style.
    ///
    ///  * Create a new Raster Tile Source — [MGLRasterTileSource](https://docs.mapbox.com/ios/api/maps/5.9.0/Classes/MGLRasterTileSource.html)
    ///  * Managing Sources —
    ///    * [removeSource](https://docs.mapbox.com/ios/api/maps/5.9.0/Classes/MGLStyle.html#/c:objc(cs)MGLStyle(im)removeSource:error:)
    ///    * [addSource](https://docs.mapbox.com/ios/api/maps/5.9.0/Classes/MGLStyle.html#/c:objc(cs)MGLStyle(im)addSource:)
    ///
    ///   # Exceptions #
    ///   * There are two possible exceptions we are trying to avoid.  From the API:
    ///     *  *Adding the same source instance more than once will result in a* `MGLRedundantSourceException`.
    ///     * *Reusing the same source identifier, even with different source instances, will result in a* `MGLRedundantSourceIdentifierException`.
    ///
    ///   # Debugger (lldb) #
    ///   `# print out the Sources & Layers for inspection`
    /**
```
# The layers included in the style, arranged according to their back-to-front ordering on the screen.
po mapView.style?.layers

# A set containing the style’s sources.
po mapView.style?.sources
```
     */
    func updateRasterSource() {
        
        let identifier = "osm"
        let sourceIdentifier = "source-" + identifier
        let layerIdentifier = "layer-" + identifier

        let source = MGLRasterTileSource(identifier: sourceIdentifier,
                                         tileURLTemplates: ["https://tile.openstreetmap.org/{z}/{x}/{y}.png"],
                                         options: [
                                            .minimumZoomLevel: 0,
                                            .maximumZoomLevel: 14,
                                            .tileSize: 256,
                                            .attributionInfos: [
                                                MGLAttributionInfo(title: NSAttributedString(string: "© OSM"),
                                                                   url: URL(string:"https://operations.osmfoundation.org/policies/tiles/"))]
        ])
        
        // check if Source already exists in Mapbox Style
        if let s = mapView.style?.source(withIdentifier: sourceIdentifier) {
            /// Source *already* exists, so continue
            #if DEBUG
            print(s)
            #endif
        } else {
            /// Source does *not* exist, so add both Source & Layer to Mapbox Style
            mapView.style?.addSource(source)
            let rasterLayer = MGLRasterStyleLayer(identifier: layerIdentifier, source: source)
            mapView.style?.addLayer(rasterLayer)
        }
        
        #if DEBUG
        print(mapView.style?.layers)
        print(mapView.style?.sources)
        #endif
    }
    
    /// Operate on `grids` and compute the bounding box for each
    func gridcomputeBoundingBox() {
        for (index, element) in grids.names.enumerated() {
            print(index, ":", element)
            let bbox = computeBoundingBoxUpdateUI()

            grids.coordinates.append(bbox)
        }
    }
    
    /// start Offline Download for each grid
    func gridStartOfflineDownload() {
        for (index, element) in grids.coordinates.enumerated() {
            print(index, ":", element)
            startOfflinePackDownload(boundingBox: element, offlineName: "Offline Maps for Mobile")
        }
    }

    /// - Tag: tagTilePicker
    func computeBoundingBoxUpdateUI() -> MGLCoordinateBounds {
        
        var returnBounds = MGLCoordinateBounds()
        guard let layer = mapView.style?.layer(withIdentifier: grids.layerIdentifier) as? MGLFillStyleLayer else {
            fatalError("Could not cast to specified MGLFillStyleLayer")
        }
        
        let goodCampingIslands = grids.names
        layer.predicate = NSPredicate(format: "name IN %@", sanJuanIslands)
        layer.fillColor = NSExpression(format: "TERNARY(name in %@, %@, %@)", goodCampingIslands, UIColor.red, UIColor.gray)  // Color selected as red, else gray
        
        /// [#16467](https://github.com/mapbox/mapbox-gl-native/issues/16467)
        /// [#85](https://github.com/mapbox/mapbox-gl-native-ios/issues/85)
        /// [#14970](https://github.com/mapbox/mapbox-gl-native/issues/14970)
        /// Test & triage of how to use `featuresMatchingPredicate`
        if let s = mapView.style?.source(withIdentifier: grids.sourceIdentifier) as? MGLShapeSource {
            let features1 = s.features(matching: nil)
            print("features1 \(features1.count)")
            let features2 = s.features(matching: NSPredicate(format: "name IN %@", goodCampingIslands) )
            print("features2 \(features2.count)")

            /**
             /// Cast the result to `MGLFeaturePolygon`
             */
            let arrayOfPolygonFeatures = features2 as! [MGLPolygonFeature]
            let oneFeature = features2[0] as! MGLPolygonFeature
            let bounds = oneFeature.overlayBounds
            let coords = oneFeature.coordinates  // TODO: - how to use this UnsafeMutablePointer<CLLocationCoordinate2d>???
            
            /**
             /// as a test, inspect data from the first element that matches the predicate
             /// Convert to a Mapbox `geoJSONDictionary` to JSON
             */
            let dict = features2[0].geoJSONDictionary()
            guard let json = try? JSONSerialization.data(withJSONObject: dict,
                                                         options: JSONSerialization.WritingOptions()) else { return MGLCoordinateBounds() }
            let feature = try! JSONDecoder().decode(Feature.self, from: json)
            
            /// Set a breakpoint to inspect the data from the Turf `Feature` object.  These variables are unused, but here to learn and inspect GeoJSON data
            let id = feature.identifier
            let p = feature.properties
            let g = feature.geometry
            let t = feature.geometry.type
            let value = feature.geometry.value as! Polygon

            let bbox = try? BoundingBox(from: value.coordinates[0])  /// TODO: - In this example, need to access the 0th element of the array?!?
            returnBounds.sw = bbox?.southWest as! CLLocationCoordinate2D
            returnBounds.ne = bbox?.northEast as! CLLocationCoordinate2D
        }

        return returnBounds
    }

    func loadGeoJson() {
        DispatchQueue.global().async {
            // Get the path for example.geojson in the app’s bundle.
            guard let jsonUrl = Bundle.main.url(forResource: "grids", withExtension: "geojson") else {
                preconditionFailure("Failed to load local GeoJSON file")
            }

            guard let jsonData = try? Data(contentsOf: jsonUrl) else {
                preconditionFailure("Failed to parse GeoJSON file")
            }

            DispatchQueue.main.async {
                self.drawPolyline(geoJson: jsonData)
            }
        }
    }

    func drawPolyline(geoJson: Data) {
        // Add our GeoJSON data to the map as an MGLGeoJSONSource.
        // We can then reference this data from an MGLStyleLayer.

        // MGLMapView.style is optional, so you must guard against it not being set.
        guard let style = self.mapView.style else { return }

        guard let shapeFromGeoJSON = try? MGLShape(data: geoJson, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }

        let source = MGLShapeSource(identifier: grids.sourceIdentifier, shape: shapeFromGeoJSON, options: nil)
        style.addSource(source)

        // Create new layer for the line.
        let layer = MGLFillStyleLayer(identifier: grids.layerIdentifier, source: source)
        layer.fillColor = NSExpression(forConstantValue: UIColor(red: 1, green: 0, blue: 1, alpha: 0.75))
        layer.fillOpacity = NSExpression(forConstantValue: 0.5)

        style.addLayer(layer)
    }
}

// MARK: - extension Color Attributes
extension MapModelController {
    private struct Color {
        static let topRightContainer = UIColor.white
        static let topRightButton = UIColor.blue
    }
    
    // MARK: Size Attributes
    private struct Ratio {
        static let topRightContainer: CGFloat = 0.1
    }
    
    private var topRightContainerSize: CGSize {
        let h: CGFloat = 96
        return CGSize(width: h / 2, height: h)
    }
    
    private var topRightButtonSize: CGSize {
        let h = topRightContainerSize.height / 2
        let w = topRightContainerSize.width
        return CGSize(width: w, height: h)
    }
    
    private var buttonImageSize: CGSize {
        let dim = topRightButtonSize.height
        return CGSize(width: dim / 2, height: dim / 2)
    }
    
    private var viewConstraints: [NSLayoutConstraint] {
        let safeArea = view.safeAreaLayoutGuide
        
        return [
            containerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Default.padding),
            containerView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -Default.padding),
            detailsButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            detailsButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            gpsButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            gpsButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ]
    }
}

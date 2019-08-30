//
//  MapModelController.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import UIKit
import FloatingPanel
import Mapbox

private let currentFile = File(name: "points", type: "geojson")

class MapModelController: UIViewController {
    
    // MARK: Model objects
    
    var model: MapViewModel?
    private let locationManager = LocationManager.shared
    
    // MARK: View attributes/objects
    
    private var panelState: PanelState = .search {
        didSet {
            let showingSettings = panelState == .settings
            
            // hide top right buttons for settings panel
            containerView.isHidden = showingSettings
            
            // hide compass button for settings panel
            mapView.compassView.compassVisibility = showingSettings ? .hidden : .adaptive
            
            // exchange floating panels for current panelState
            exchangeFPC()
        }
    }
    
    private var fpc: FloatingPanelController!
    
    private lazy var searchVC: SearchPanelController = {
        let panelController = SearchPanelController(
            places: model!.map.mappedPlaces)
        panelController.delegate = self
        return panelController
    }()
    
    private lazy var settingsVC: SettingsPanelController = {
        let panelController = SettingsPanelController()
        panelController.delegate = self
        return panelController
    }()
    
    private lazy var mapView: MGLMapView! = {
        let mapView = MGLMapView(frame: view.bounds, styleURL: Default.style.url)
        mapView.delegate = self
        mapView.compassView.compassVisibility = .visible
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let center = model?.map.boundaries.center.clCoord ?? Default.center
        mapView.setCenter(center, zoomLevel: 9, animated: false)
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
        super.viewDidLoad()
        loadModel()
        loadSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCompass()
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
    }
    
    private func loadSubViews() {
        NSLayoutConstraint.activate(viewConstraints)
        
        // add initial floating panel controller
        addFPC()
        
        // notify GPS Button when new location services determined
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locServicesStatusChanged),
            name: .locationServicesStatusChange,
            object: nil
        )
    }
    
    private func addFPC() {
        fpc = FloatingPanelController()
        fpc.view.translatesAutoresizingMaskIntoConstraints = false
        fpc.delegate = self
        fpc.surfaceView.shadowHidden = false
        fpc.surfaceView.cornerRadius = Default.cornerRadius / 2
        fpc.surfaceView.grabberTopPadding = Default.grabberPadding
        fpc.surfaceView.grabberHandleHeight = Default.grabberHandleHeight
        configurePanel()
    }
    
    // specifically configure newly added fpc based on which panel
    private func configurePanel() {
        
        // set floating panel based on state
        switch panelState {
        case .search:
            fpc.set(contentViewController: searchVC)
            fpc.track(scrollView: searchVC.tableView)
        case .settings:
            fpc.set(contentViewController: settingsVC)
        }
        
        // add panel to parent controller
        fpc.addPanel(toParent: self, animated: true)
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
        panelState = .settings
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
    
    private func exchangeFPC() {
        // hide previous panel (removed after hidden)
        // afterwards, replace with new panel
        fpc.hide(animated: true) { self.addFPC() }
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
}

extension MapModelController: FloatingPanelControllerDelegate {
    enum PanelState {
        case search, settings
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        switch panelState {
        case .search: return SearchPanelLayout()
        case .settings: return SettingsPanelLayout()
        }
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        // animate searchVC's table showing and hiding on drag
        guard panelState == .search else { return }
        
        let y = vc.surfaceView.frame.origin.y
        let halfY = vc.originYOfSurface(for: .half)
        let tipY = vc.originYOfSurface(for: .tip)
        
        let offset = tipY - y
        let mrgn = tipY - halfY // animatable margin between half and tip positions
        
        if offset >= 0 {
            let prog = min(1.0, offset / mrgn)
            searchVC.tableView.alpha = prog
        }
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        // if searching and you start to drag
        // resign the search bar if responder
        if panelState == .search && vc.position == .full {
            searchVC.resignSearchBar()
        }
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        // if dragged fast enough for fpc to leave view:
        // renew with another fpc
        if targetPosition == .hidden {
            exchangeFPC()
        }
    }
    
    func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
        guard panelState == .search else { return }
        
        // update currentPosition variable for searchVC
        searchVC.currentPosition = vc.position
        
        // animate searchVC table alpha on position changes
        var trgt: CGFloat
        
        switch vc.position {
        case .full, .half: trgt = 1
        case .tip, .hidden: trgt = 0
        }
        
        let tbl = searchVC.tableView
        let t = Default.animationDuration
        UIView.animate(withDuration: t) { tbl.alpha = trgt }
    }
}

extension MapModelController: SearchPanelControllerDelegate {
    
    func didBeginSearching() {
        let selected = mapView.selectedAnnotations.first
        mapView.deselectAnnotation(selected, animated: true)
        fpc.move(to: .full, animated: true)
    }
    
    func didCancelSearch() {
        fpc.move(to: .half, animated: true)
    }
    
    func didSelect(place: Place) {
        searchVC.resignSearchBar()
        let matches = model!.annotations.filter { $0.place == place }
        guard let annotation = matches.first else { return }
        
        fpc.move(to: .tip, animated: true) {
            self.mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
        }
    }
}

extension MapModelController: SettingsPanelControllerDelegate {
    func styleSelected(_ style: MapStyle) {
        model?.updateStyle(to: style)
        mapView.styleURL = style.url
    }
    
    func didDismiss() {
        // hide settings fpc on dismissal call from settings controller
        // do so by setting panelState, which fires fpc exchange method
        panelState = .search
    }
}

extension MapModelController {
    // MARK: Color Attributes
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


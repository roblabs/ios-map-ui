//
//  SettingsPanelController.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import UIKit
import FloatingPanel

protocol SettingsPanelControllerDelegate: class {
    var fpc: FloatingPanelController! { get set }
    func styleSelected(_ style: MapStyle)
    func didDismiss()
}

class SettingsPanelController: UIViewController {
    
    weak var delegate: SettingsPanelControllerDelegate?
    private let styles = MapStyleCollection.allStyles
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Size.font)
        label.text = "Maps Settings"
        firstContainer.addSubview(label)
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "circleX_icon"), for: .normal)
        view.addSubview(button)
        return button
    }()
    
    private lazy var styleControl: UISegmentedControl = {
        let titles = styles.map { $0.title }
        let control = UISegmentedControl(items: titles)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(styleChanged(_:)), for: .valueChanged)
        firstContainer.addSubview(control)
        // select user's default mapStyle initially
        let dflt = UserDefaults.standard.mapStyle
        let index = styles.firstIndex(where: { $0 == dflt })!
        control.selectedSegmentIndex = index
        return control
    }()
    
    private lazy var markButton = createButton(
        "Mark My Location",
        selector: #selector(markTapped)
    )
    
    private lazy var addButton = createButton(
        "Add a Place",
        selector: #selector(addTapped)
    )
    
    private lazy var reportButton = createButton(
        "Report an Issue",
        selector: #selector(reportTapped)
    )
    
    private func createButton(_ title: String, selector: Selector) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(Color.buttonFont, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        secondContainer.addSubview(button)
        return button
    }
    
    private func createContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.container
        self.view.addSubview(view)
        return view
    }
    
    private lazy var firstContainer = createContainerView()
    private lazy var secondContainer = createContainerView()
    private weak var thirdController: SettingCollectionController!
    
    private lazy var showSettingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Configure Settings", for: .normal)
        button.addTarget(self, action: #selector(showSettingsTapped), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.bg
        addSettingCollectionController()
        displayInitialCollectionControls()
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let shouldShowCollectionOption = size.height > size.width
        let pos = delegate!.fpc.position
        
        let btn = showSettingsButton
        let ctrl = thirdController.view!
        
        btn.isHidden = !shouldShowCollectionOption
        ctrl.isHidden = !shouldShowCollectionOption
        
        coordinator.animate(alongsideTransition: { _ in
            if shouldShowCollectionOption {
                if pos == .full {
                    ctrl.alpha = 1
                } else {
                    btn.alpha = 1
                }
            } else {
                ctrl.alpha = 0
                btn.alpha = 0
            }
        })
    }
    
    private func addSettingCollectionController() {
        let scc = SettingCollectionController()
        thirdController = scc
        
        addChild(thirdController!)
        thirdController!.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thirdController!.view)
        thirdController!.didMove(toParent: self)
        
        NSLayoutConstraint.activate(thirdControllerConstraints)
    }
    
    private func displayInitialCollectionControls() {
        thirdController.view.alpha = 0
        thirdController.view.isHidden = true
        
        let size = UIScreen.main.bounds.size
        let show = size.width < size.height
        print("displayInitialCollectionControls: \(show)")
        showSettingsButton.alpha = show ? 1 : 0
        showSettingsButton.isHidden = !show
    }
    
    // MARK: User Action methods
    
    @objc func styleChanged(_ sender: UISegmentedControl) {
        let style = styles[sender.selectedSegmentIndex]
        delegate?.styleSelected(style)
    }
    
    @objc func exitTapped() {
        delegate?.didDismiss()
    }
    
    @objc func markTapped() {
        
    }
    
    @objc func addTapped() {
        
    }
    
    @objc func reportTapped() {
        
    }
    
    @objc func showSettingsTapped() {
        self.delegate?.fpc.move(to: .full, animated: true, completion: { [weak self] in
            self?.showSettingsCollection()
        })
    }
    
    func showSettingsCollection() {
        thirdController.view.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.showSettingsButton.alpha = 0
            self.thirdController.view.alpha = 1
        }) { _ in
            self.showSettingsButton.isHidden = true
        }
    }
    
    func hideSettingsCollection() {
        showSettingsButton.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.thirdController.view.alpha = 0
            self.showSettingsButton.alpha = 1
        }) { _ in
            self.thirdController.view.isHidden = true
        }
    }
}

extension SettingsPanelController {
    
    private struct Color {
        static let bg = UIColor.lightGray
        static let container = UIColor.lightText
        static let font = UIColor.black
        static let buttonFont = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    }
    
    private struct Ratio {
        static let title: CGFloat = 0.5
        static let exitButton = title / 3
        static let mappingButton: CGFloat = 1/3
    }
    
    private struct Size {
        static let font: CGFloat = 20
        static let padding = Default.padding * 2
        
        // views
        static let containerHeight: CGFloat = 120
        static let titleHeight = containerHeight * Ratio.title
        static let segCntrlHeight: CGFloat = 32 // default segmentedControl height
        static let exitButtonHeight = containerHeight * Ratio.exitButton
        static let mappingButtonHeight = containerHeight * Ratio.mappingButton
    }
    
    private struct Time {
        static let animation: TimeInterval = Default.animationDuration
    }
    
    private var viewConstraints: [NSLayoutConstraint] {
        return [
            firstContainer.topAnchor.constraint(equalTo: view.topAnchor),
            firstContainer.heightAnchor.constraint(equalToConstant: Size.containerHeight),
            firstContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            firstContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: firstContainer.topAnchor, constant: Default.grabberInset),
            titleLabel.heightAnchor.constraint(equalToConstant: Size.titleHeight),
            titleLabel.leftAnchor.constraint(equalTo: firstContainer.leftAnchor, constant: Size.padding),
            titleLabel.rightAnchor.constraint(equalTo: firstContainer.rightAnchor, constant: -Size.padding),
            
            exitButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            exitButton.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            exitButton.heightAnchor.constraint(equalToConstant: Size.exitButtonHeight),
            exitButton.widthAnchor.constraint(equalToConstant: Size.exitButtonHeight),
            
            styleControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            styleControl.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            styleControl.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            styleControl.heightAnchor.constraint(equalToConstant: Size.segCntrlHeight),
            
            secondContainer.topAnchor.constraint(equalTo: firstContainer.bottomAnchor, constant: Default.padding),
            secondContainer.heightAnchor.constraint(equalToConstant: Size.containerHeight),
            secondContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            secondContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            markButton.heightAnchor.constraint(equalToConstant: Size.mappingButtonHeight),
            markButton.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            markButton.topAnchor.constraint(equalTo: secondContainer.topAnchor),
            markButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),

            addButton.heightAnchor.constraint(equalToConstant: Size.mappingButtonHeight),
            addButton.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            addButton.topAnchor.constraint(equalTo: markButton.bottomAnchor),
            addButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            
            reportButton.heightAnchor.constraint(equalToConstant: Size.mappingButtonHeight),
            reportButton.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            reportButton.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            reportButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            
            showSettingsButton.topAnchor.constraint(equalTo: secondContainer.bottomAnchor, constant: Size.padding),
            showSettingsButton.heightAnchor.constraint(equalToConstant: Size.segCntrlHeight),
            showSettingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
    }
    
    private var thirdControllerConstraints: [NSLayoutConstraint] {
        [
            thirdController.view.topAnchor.constraint(equalTo: secondContainer.bottomAnchor, constant: Default.padding),
            thirdController.view.leftAnchor.constraint(equalTo: secondContainer.leftAnchor),
            thirdController.view.rightAnchor.constraint(equalTo: secondContainer.rightAnchor),
            thirdController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Default.padding),
        ]
    }
}

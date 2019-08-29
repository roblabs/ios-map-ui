//
//  SettingsPanelController.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsPanelControllerDelegate: class {
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
        label.activateAnchors(for: titleSize)
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
        button.activateAnchors(for: buttonSize)
        view.addSubview(button)
        return button
    }()
    
    private lazy var styleControl: UISegmentedControl = {
        let titles = styles.map { $0.title }
        let control = UISegmentedControl(items: titles)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.activateAnchors(for: segCntlSize)
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
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: itemSize.height),
            button.widthAnchor.constraint(lessThanOrEqualToConstant: itemSize.width)
            ])
        secondContainer.addSubview(button)
        return button
    }
    
    private func createContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.container
        view.activateAnchors(for: containerSize)
        self.view.addSubview(view)
        return view
    }
    
    private lazy var firstContainer = createContainerView()
    private lazy var secondContainer = createContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.bg
        NSLayoutConstraint.activate(viewConstraints)
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
}

extension SettingsPanelController {
    
    private struct Size {
        static let font: CGFloat = 20
        static let padding = Default.padding
    }
    
    private struct Color {
        static let bg = UIColor.lightGray
        static let container = UIColor.lightText
        static let font = UIColor.black
        static let buttonFont = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    }
    
    private struct Ratio {
        static let panel: CGFloat = 0.5
        static let container: CGFloat = panel * 2/5
        static let title = container / 2
        static let item = container / 3
    }
    
    private struct Time {
        static let animation: TimeInterval = Default.animationDuration
    }
    
    private var containerSize: CGSize {
        let w = view.bounds.width
        let h = view.bounds.height * Ratio.container
        return CGSize(width: w, height: h)
    }
    
    private var titleSize: CGSize {
        let w = view.frame.size.width - (Size.padding * 2)
        let h = view.bounds.height * Ratio.title
        return CGSize(width: w, height: h)
    }
    
    private var itemSize: CGSize {
        let w = view.frame.size.width - (Size.padding * 2)
        let h = view.bounds.height * Ratio.item
        return CGSize(width: w, height: h)
    }
    
    private var segCntlSize: CGSize {
        let w = itemSize.width
        let h: CGFloat = 32 // default seg control height
        return CGSize(width: w, height: h)
    }
    
    private var buttonSize: CGSize {
        let h = titleSize.height / 3
        let w = h
        return CGSize(width: w, height: h)
    }
    
    private var viewConstraints: [NSLayoutConstraint] {
        return [
            firstContainer.topAnchor.constraint(equalTo: view.topAnchor),
            firstContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: firstContainer.topAnchor, constant: Default.grabberInset),
            titleLabel.leftAnchor.constraint(equalTo: firstContainer.leftAnchor, constant: Size.padding),
            exitButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            exitButton.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            styleControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            styleControl.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            secondContainer.topAnchor.constraint(equalTo: firstContainer.bottomAnchor, constant: Default.padding / 2),
            secondContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            markButton.topAnchor.constraint(equalTo: secondContainer.topAnchor),
            markButton.leftAnchor.constraint(equalTo: secondContainer.leftAnchor, constant: Default.padding),
            addButton.topAnchor.constraint(equalTo: markButton.bottomAnchor),
            addButton.leftAnchor.constraint(equalTo: markButton.leftAnchor),
            reportButton.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            reportButton.leftAnchor.constraint(equalTo: markButton.leftAnchor),
        ]
    }
}

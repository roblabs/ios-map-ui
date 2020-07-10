//
//  SettingsCollectionController.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 7/9/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import UIKit

class SettingCollectionController : UIViewController {
    private let settings = SettingDatasource.settings
    private lazy var currentSetting = settings.first!
    
    private let cv: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .vertical
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: l)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.reuseId)
        
        return cv
    }()
    
    private weak var detailController: SettingDetailController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.container
        configureViews()
    }
    
    private func configureViews() {
        cv.dataSource = self
        cv.delegate = self
        view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            cv.leftAnchor.constraint(equalTo: view.leftAnchor),
            cv.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        updateDetailController()
    }
    
    private func updateDetailController() {
        if detailController != nil {
            detailController.willMove(toParent: self)
            detailController.view.removeFromSuperview()
            detailController.removeFromParent()
        }
        
        let dc = SettingDetailController(setting: currentSetting)
        detailController = dc
        addChild(detailController)
        
        detailController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailController.view)
        detailController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            detailController.view.topAnchor.constraint(equalTo: cv.bottomAnchor, constant: 8),
            detailController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

extension SettingCollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.width
        let s = w / 4
        return CGSize(width: s, height: s)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCollectionViewCell.reuseId, for: indexPath) as! SettingCollectionViewCell
        
        let s = settings[indexPath.row]
        cell.setCell(setting: s)
        
        if s == currentSetting {
            cell.toggleCellSelection()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let s0 = currentSetting
        let s1 = settings[indexPath.row]
        
        currentSetting = s1
        
        if s0 != s1 {
            let i0 = settings.firstIndex(of: s0)!
            let ip0 = IndexPath(item: i0, section: 0)
            
            let c0 = collectionView.cellForItem(at: ip0) as! SettingCollectionViewCell
            let c1 = collectionView.cellForItem(at: indexPath) as! SettingCollectionViewCell
            
            c0.toggleCellSelection()
            c1.toggleCellSelection()
            updateDetailController()
        }
    }
}

extension SettingCollectionController {
    private struct Color {
        static let bg = UIColor.lightText
        static let container = UIColor.lightText
        static let font = UIColor.black
        static let buttonFont = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    }
}

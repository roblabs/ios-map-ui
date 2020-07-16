//
//  SettingCollectionViewCell.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 7/9/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewCell {
    static let reuseId = "SettingCollectionViewCell"
    
    private var settingShowing = false
    
    private let iv: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let lbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        contentView.addSubview(iv)
        contentView.addSubview(lbl)

        let pd: CGFloat = 8

        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: pd),
            iv.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: pd),
            iv.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -pd),
            iv.bottomAnchor.constraint(equalTo: lbl.topAnchor, constant: -pd),
            lbl.heightAnchor.constraint(equalToConstant: 24),
            lbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -pd),
            lbl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: pd),
            lbl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -pd),
        ])
    }
    
    func setCell(setting: Setting) {
        layoutIfNeeded()
        setAndScaleImage(withName: setting.imageTitle)
        lbl.text = setting.title
        lbl.sizeToFit()
    }
    
    func setAndScaleImage(withName name: String) {
        if let img = UIImage(named: name) {
            iv.image = img
            
            // if too big, scale down, otherwise center
            let s = img.size
            let big = s.height > iv.bounds.height || s.width > iv.bounds.width
            iv.contentMode = big ? .scaleAspectFit : .center
        }
    }
    
    func toggleCellSelection() {
        settingShowing = !settingShowing
        
        backgroundColor = settingShowing ? .systemBlue : .clear
        lbl.textColor = settingShowing ? .white : .black
    }
}

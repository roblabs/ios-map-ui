//
//  CategoryCollectionViewCell.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var imageBgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            let bgColor = isSelected ? Color.selected : Color.normal
            contentView.backgroundColor = bgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        NSLayoutConstraint.activate(viewConstraints)
        imageBgView.layer.cornerRadius = imageViewSizeDim / 2
        imageView.setImageColor(color: Color.icon)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setCell(with category: PlaceCategory) {
        label.text = category.title
        imageView.image = category.image
        imageBgView.backgroundColor = category.color
    }
}

extension CategoryCollectionViewCell {
    
    private struct Ratio {
        static let image: CGFloat = 0.5
    }
    
    private struct Color {
        static let normal = UIColor.clear
        static let selected = UIColor.gray
        static let icon = UIColor.white
    }
    
    private var imageViewSizeDim: CGFloat {
        return (contentView.bounds.height * 3/4) - Default.padding
    }
    
    private var viewConstraints: [NSLayoutConstraint] {
        return [
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            label.heightAnchor.constraint(equalToConstant: contentView.frame.size.height / 4),
            imageBgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Default.padding / 2),
            imageBgView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -Default.padding / 2),
            imageBgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageBgView.widthAnchor.constraint(equalTo: imageBgView.heightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageBgView.heightAnchor, multiplier: Ratio.image),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageBgView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageBgView.centerXAnchor),
        ]
    }
}


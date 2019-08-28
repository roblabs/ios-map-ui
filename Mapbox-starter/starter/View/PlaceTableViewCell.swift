//
//  PlaceTableViewCell.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import UIKit

class PlaceTableViewCell: UITableViewCell {
    var place: Place! {
        didSet { configureCell() }
    }
    
    // override style variable in init to allow detail label
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    private func configureCell() {
        // set labels
        textLabel?.text = place.title
        let size = textLabel!.font.pointSize
        textLabel?.font = UIFont.boldSystemFont(ofSize: size)
        detailTextLabel?.text = place.description
        detailTextLabel?.alpha = 0.75
        
        // set image based on category
        let image = place.category.image
        imageView?.image = image?.resize(to: imageSize)
        imageView?.backgroundColor = place.category.color
        imageView?.setImageColor(color: .white)
    }
    
    override var imageView: UIImageView? {
        let imageView = super.imageView
        imageView?.layer.cornerRadius = imageSize.height / 2
        return imageView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil // reset image w reuse
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imageSize: CGSize {
        let dim = contentView.frame.size.height / 2.5
        return CGSize(width: dim, height: dim)
    }
}

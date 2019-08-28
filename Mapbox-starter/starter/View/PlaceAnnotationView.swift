//
//  PlaceAnnotationView.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import Mapbox

class PlaceAnnotationView: MGLAnnotationView {
    
    init(placeAnnotation: PlaceAnnotation, reuseIdentifier: String?) {
        super.init(annotation: placeAnnotation, reuseIdentifier: reuseIdentifier)
        bounds = CGRect(origin: .zero, size: Size.bounds)
        backgroundColor = bgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlaceAnnotationView {
    
    private struct Size {
        static let bounds = CGSize(width: 40, height: 40)
    }
    
    var bgColor: UIColor {
        let pA = annotation as! PlaceAnnotation
        return pA.category.color
    }
}

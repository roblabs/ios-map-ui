//
//  SearchPanelLayout.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import FloatingPanel

class SearchPanelLayout: FloatingPanelLayout {
    
    public var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.hidden, .tip, .half, .full]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return PanelInset.full // 16 A top inset from safe area
        case .half: return PanelInset.half // 224 A bottom inset from the safe area (old value: 216)
        case .tip: return PanelInset.tip // 48 A bottom inset from the safe area (old value: 44)
        case .hidden: return nil
        }
    }
    
    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        let pH = view.bounds.height
        let pW = view.bounds.width
        
        let w = min(pH, pW)
        
        return [
            surfaceView.widthAnchor.constraint(equalToConstant: w),
            surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ]
    }
}

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
    
    var parentSize: CGSize
    
    private var halfInset: CGFloat {
        let h = parentSize.height
        return h / 2
    }
    
    init(parentSize: CGSize) {
        self.parentSize = parentSize
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.hidden, .tip, .half, .full]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return PanelInset.full // Single Padding from top
        case .half: return halfInset // half way up the view's height
        case .tip: return PanelInset.tip // offset from bottom to include grabber and searchBar
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

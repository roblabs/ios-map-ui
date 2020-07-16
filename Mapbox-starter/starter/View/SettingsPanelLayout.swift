//
//  SettingsPanelLayout.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 8/28/19.
//  Copyright © 2019 ePi Rational, Inc. All rights reserved.
//

import Foundation
import FloatingPanel

class SettingsPanelLayout: FloatingPanelLayout {
    
    var parentSize: CGSize
    
    private var halfInset: CGFloat { return parentSize.height / 2 }
    
    private var isLandscape: Bool {
        return parentSize.height < parentSize.width
    }
    
    init(parentSize: CGSize) {
        self.parentSize = parentSize
    }
    
    public var initialPosition: FloatingPanelPosition {
        return isLandscape ? .full : .half
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return isLandscape ? [.hidden, .full] : [.hidden, .half, .full]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .hidden: return nil
        case .full: return PanelInset.full
        case .half: return isLandscape ? PanelInset.full : halfInset
        case .tip: return nil // not supported
        }
    }
    
    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        let pH = view.bounds.height
        let pW = view.bounds.width

        let w = min(pH, pW)
        
        // have settings panel layout fill entire phone on landscape
        return [
            surfaceView.widthAnchor.constraint(equalToConstant: w),
            surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ]
    }
}

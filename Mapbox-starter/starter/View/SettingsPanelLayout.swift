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
    
    public var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.hidden, .full]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        if position == .full { return PanelInset.half }
        return nil
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

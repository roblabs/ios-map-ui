//
//  LogManager.swift
//  Mapbox-starter
//
//  Created by Wilson Desimini on 1/30/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import Foundation
import os.signpost

class LogManager {
    
    static func signpostBegin(event: Event) {
        if #available(iOS 12.0, *) {
            signpost(.begin, event: event)
        }
    }
    
    static func signpostEnd(event: Event) {
        if #available(iOS 12.0, *) {
            signpost(.end, event: event)
        }
    }
    
    static func signpostEvent(event: Event) {
        if #available(iOS 12.0, *) {
            signpost(.event, event: event)
        }
    }
    
    private static func signpost(_ type: OSSignpostType, event: Event) {
        if #available(iOS 12.0, *) {
            let oslog = OSLog(subsystem: LogCredentials.subsystem, category: event.category)
            os_signpost(type, log: oslog, name: event.name)
        }
    }
    
}

extension LogManager {
    
    private struct LogCredentials {
        static let subsystem = "roblabs.com.ios-map-ui"
    }
    
    enum Event {
        
        case appDelegate(_ event: AppDelegateEvent)
        case mapModelController(_ event: UIViewControllerEvent)
        
        enum AppDelegateEvent {
            case didBecomeActive
            case willEnterForeground
        }
        
        enum UIViewControllerEvent {
            case viewDidLoad
        }
        
        var category: String {
            switch self {
            case .appDelegate(_): return "AppDelegate"
            case .mapModelController(_): return "MapModelController"
            }
        }
        
        var name: StaticString {
            switch self {
            case .appDelegate(let event):
                switch event {
                case .didBecomeActive: return "applicationDidBecomeActive"
                case .willEnterForeground: return "applicationWillEnterForeground"
                }
            case .mapModelController(let event):
                switch event {
                case .viewDidLoad: return "viewDidLoad"
                }
            }
        }
        
    }
    
}

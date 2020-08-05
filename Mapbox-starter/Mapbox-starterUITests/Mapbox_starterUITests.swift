//
//  Mapbox_starterUITests.swift
//  Mapbox-starterUITests
//
//  Created by Rob Labs on 8/4/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import XCTest
@testable import Mapbox

class Mapbox_starterUITests: XCTestCase {
    
    var app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunch() throws {
        app.launch()
    }

    func testStyles() {
        // generated from recording a UI test
        app.launch()

        // Info button, upper right corner
        app.buttons["More Info"].tap()
        
        // Change Styles
        app/*@START_MENU_TOKEN@*/.buttons["Light"]/*[[".segmentedControls.buttons[\"Light\"]",".buttons[\"Light\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Satellite"]/*[[".segmentedControls.buttons[\"Satellite\"]",".buttons[\"Satellite\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Streets"]/*[[".segmentedControls.buttons[\"Streets\"]",".buttons[\"Streets\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                app.launch()
            }
        }
    }
}

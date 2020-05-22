//
//  MapKit_starterUITests.swift
//  MapKit-starterUITests
//
//  Created by Rob Labs on 1/1/20.
//  Copyright © 2020 Rob Labs. All rights reserved.
//

import XCTest

class MapKit_starterUITests: XCTestCase {

    var app = XCUIApplication()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func languageLocale(language: String, locale: String) {

        app.launchArguments = [
            "-inUITest",
            "-AppleLanguages",
            "(" + language + ")",  // paranthesis are required
            "-AppleLocale",
            locale
        ]

        app.launch()

        let map = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        map.tap()
        sleep(3)
    }
    
    func testGerman() {
        languageLocale(language: "de", locale: "de_DE")
    }

    func testPortuguese() {
        languageLocale(language: "pt", locale: "pt_PT")
        languageLocale(language: "pt", locale: "pt_BR")
    }
    
    func testSpanish() {
        languageLocale(language: "es", locale: "es_ES")
        languageLocale(language: "es", locale: "es_MX")
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

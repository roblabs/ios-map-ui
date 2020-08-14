//
//  Mapbox_starterTests.swift
//  Mapbox-starterTests
//
//  Created by Rob Labs on 7/24/20.
//  Copyright © 2020 ePi Rational, Inc. All rights reserved.
//

import XCTest

class Mapbox_starterTests: XCTestCase {
    
    var sanJuanIslands = ["Orcas", "Jones", "Sucia", "Matia", "Stuart", "Johns"]
    var goodCampingIslands = ["Jones", "Sucia", "Matia"]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // append, insert, remove from Arrays
    func testArrayElements() throws {
        for island in sanJuanIslands {
            print("Let's go to \(island) Island.")
        }

        sanJuanIslands.append("Cypress")
        print(sanJuanIslands)
        sanJuanIslands.append(contentsOf: ["Shaw", "Blakely"])
        print(sanJuanIslands)
        
        sanJuanIslands.insert("Lopez", at: 3)
        print(sanJuanIslands)
        
        sanJuanIslands.remove(at: 0)
        print(sanJuanIslands)
        
        let islandIndex = sanJuanIslands.firstIndex(of: "Sucia")
        print(sanJuanIslands)
        print("Sucia is at element \(String(describing: islandIndex))")
        
        sanJuanIslands.remove(at: islandIndex!)
        print(sanJuanIslands)
    }
    
    // Using NSPredicate to Filter an Array
    func testPredicateFilterArray() {
        let predicate = NSPredicate(format: "self BEGINSWITH $letter")

        let kvpLetterS = ["letter": "S"]
        let beginsWithS = predicate.withSubstitutionVariables(kvpLetterS)
        let sanJuanIslandsStartingWithS = sanJuanIslands.filter { beginsWithS.evaluate(with: $0) }
        print(sanJuanIslandsStartingWithS)

        let kvpLetterJ = ["letter": "J"]
        let beginsWithJ = predicate.withSubstitutionVariables(kvpLetterJ)
        let sanJuanIslandsStartingWithJ = sanJuanIslands.filter { beginsWithJ.evaluate(with: $0) }
        print(sanJuanIslandsStartingWithJ)  
    }
}

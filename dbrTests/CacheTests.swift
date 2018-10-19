//
//  dbrTests.swift
//  dbrTests
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import XCTest
import Foundation
@testable import dbr

class CacheTests: XCTestCase {
    
    struct TestableItem: Codable {
        let name: String
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCache() {
        let sut = CacheService()
        
        sut.persist(TestableItem(name: "YOLO"), key: "testable")
        
        guard let item: TestableItem = sut.retrieve("testable") else { return XCTFail("Failed to retrieve data") }
        
        XCTAssert(item.name == "YOLO", "Failed to get the correctly named item from cache")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

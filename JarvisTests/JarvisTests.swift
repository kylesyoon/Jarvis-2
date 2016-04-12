//
//  JarvisTests.swift
//  JarvisTests
//
//  Created by Yoon, Kyle on 4/12/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import XCTest
@testable import Jarvis

class JarvisBaseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        JARTestHelper.sharedInstance.isUnitTesting = true
    }
    
    override func tearDown() {
        JARTestHelper.sharedInstance.isUnitTesting = false
        super.tearDown()
    }
    
}

//
//  YumeAlamofireTests.swift
//  YumeAlamofireTests
//
//  Created by Yume on 2018/1/11.
//  Copyright © 2018年 Yume. All rights reserved.
//

import XCTest
import Alamofire
import JSONDecodeKit
import AwaitKit

//https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations/testing_asynchronous_operations_with_expectations
class YumeAlamofireTests: XCTestCase {
    
    func testExample() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        async {
            do {
                let a = try await(Entry.A(key: "").promise)
                
                XCTAssertEqual(a.code, 3)
//                print("yume \(a.code)")
                expectation.fulfill()
            } catch {
                XCTAssertTrue(false)
            }
        }
            
        wait(for: [expectation], timeout: 15.0)
    }
}


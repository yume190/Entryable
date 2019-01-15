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
@testable import YumeAlamofire
@testable import JSONMock

//https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations/testing_asynchronous_operations_with_expectations
class YumeAlamofireTests: XCTestCase {
    static var s: SessionManager?
    let fakeRes = Entry.A.Response(code: 3, message: "abc")
    
    open override class func setUp() {
        super.setUp()
        Swizzle.swizzle()
    }
    
    func testURLSession() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        let entry = Entry.A(key: "")
        
        let url = try! entry.url.asURL()
        let urlRequest = URLRequest(url: url)
        JSONMock.fake(
            url: url.absoluteString,
            fake: .json(json: fakeRes, code: 201, header: [:])
        )
        
        let s = URLSession(configuration: URLSessionConfiguration.default)
        s.dataTask(with: urlRequest) { data, response, error in
            let d = JSONDecoder()
            let res = try? d.decode(Entry.A.Response.self, from: data!)
            XCTAssertEqual(res, self.fakeRes)
            XCTAssertEqual((response as! HTTPURLResponse).statusCode, 201)
            expectation.fulfill()
        }.resume()
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    func testAlamofire1() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        try! JSONMock.fake(
            url: Entry.A(key: "").url.asURL().absoluteString,
            fake: .json(json: self.fakeRes, code: 202, header: [:])
        )
        async {
            do {
                let res = try Entry.A(key: "").promise.await()
                XCTAssertEqual(res.data, self.fakeRes)
                XCTAssertEqual(res.response.statusCode, 202)
//                XCTAssertEqual(res.response.allHeaderFields, [:])
                expectation.fulfill()
            } catch {
                print(error)
                XCTAssertTrue(false)
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testAlamofire2() {
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        try! JSONMock.fake(
            url: Entry.B(key: "").url.asURL().absoluteString,
            fake: .json(json: self.fakeRes, code: 202, header: ["a":"b"])
        )
        async {
            do {
                let res = try Entry.B(key: "").promiseVoid.await()
                XCTAssertEqual(res.response.statusCode, 202)
                XCTAssertEqual(res.response.allHeaderFields as! [String:String], ["a":"b"])
                expectation.fulfill()
            } catch {
                print(error)
                XCTAssertTrue(false)
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
}


//
//  YumeAlamofireTests.swift
//  YumeAlamofireTests
//
//  Created by Yume on 2018/1/11.
//  Copyright © 2018年 Yume. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import RxEntryable
@testable import Entryable
@testable import JSONMock

let fakeRes = Entry.A.Response(code: 3, message: "abc")

//https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations/testing_asynchronous_operations_with_expectations
class YumeAlamofireTests: XCTestCase {
    
    open override class func setUp() {
        super.setUp()
        URLSessionConfiguration.swizzle()
        //        Swizzle.swizzle()
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
            XCTAssertEqual(res, fakeRes)
            XCTAssertEqual((response as! HTTPURLResponse).statusCode, 201)
            expectation.fulfill()
        }.resume()
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testAsync() async throws {
        try! JSONMock.fake(
            url: Entry.A(key: "").url.asURL().absoluteString,
            fake: .json(json: fakeRes, code: 201, header: [:])
        )
        
        let res: HTTPRawResponse<Entry.A.Response> = try await Entry.A(key: "").fetch()
        print(res.data)
        XCTAssertEqual(res.data, fakeRes)
        XCTAssertEqual(res.response?.statusCode, 201)
    }
    
    func testRx() {
        let bag = DisposeBag()
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        try! JSONMock.fake(
            url: Entry.A(key: "").url.asURL().absoluteString,
            fake: .json(json: fakeRes, code: 202, header: ["a":"b"])
        )
        Entry.A(key: "").rx.subscribe(onSuccess: { (res: HTTPRawResponse<Entry.A.Response>) in
            XCTAssertEqual(res.data, fakeRes)
            XCTAssertEqual(res.response?.statusCode, 202)
            XCTAssertEqual(res.response?.headers.dictionary, ["a":"b"])
            expectation.fulfill()
        }, onFailure: { error in
            print(error)
            XCTAssertTrue(false)
        }).disposed(by: bag)
        
        wait(for: [expectation], timeout: 3.0)
    }
}


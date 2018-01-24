////
////  YumeAlamofireTests.swift
////  YumeAlamofireTests
////
////  Created by Yume on 2018/1/11.
////  Copyright © 2018年 Yume. All rights reserved.
////
//
//import XCTest
//import Alamofire
//import JSONDecodeKit
//
//class YumeAlamofireTests: XCTestCase {
//    func testExample() {
//        let latch = CountdownLatch()
//        latch.enter()
//        var result: Entry.BaseDatas.Response? = nil
//        Entry.BaseDatas().req(failureHandler: { (res:DefaultDataResponse) in
////            if let data = res.data {
////                let str = String.init(data: data, encoding: .utf8)!
////                print(str)
////            }
//            latch.leave()
//            fatalError()
//        }) { (res:Entry.BaseDatas.Response) in
//            result = res
//            latch.leave()
//        }
//        
//        
//        let executionTimeout:DispatchTimeInterval = DispatchTimeInterval.seconds(10)
//        if latch.wait(interval: executionTimeout){
//            XCTAssertEqual(result?.code, 0)
//            XCTAssertEqual(result?.message, "ok")
//            print("complete")
//        }else {
//            print("not complete")
//            fatalError()
//        }
//    }
//}


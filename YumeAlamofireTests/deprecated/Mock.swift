////
////  Mock.swift
////  YumeAlamofireTests
////
////  Created by Yume on 2018/6/12.
////  Copyright © 2018年 Yume. All rights reserved.
////
//
//import Foundation
//import XCTest
//
//protocol APIRequest {
//    associatedtype RequestDataType
//    associatedtype ResponseDataType
//    func request(from data: RequestDataType) throws -> URLRequest
//    func response(data: Data) throws -> ResponseDataType
//}
//
//class APIRequestLoader<T: APIRequest> {
//    let apiRequest: T
//    let urlSession: URLSession
//    init(apiRequest: T, urlSession: URLSession = .shared) {
//        self.apiRequest = apiRequest
//        self.urlSession = urlSession
//    }
//    
//    func loadAPIRequest(
//        requestData: T.RequestDataType,
//        completionHandler: @escaping (T.ResponseDataType?, Error?) -> Void) {
//        do {
//            let urlRequest = try apiRequest.request(from: requestData)
//            urlSession.dataTask(with: urlRequest) { data, response, error in
//                guard let data = data else { return completionHandler(nil, error) }
//                do {
//                    let parsedResponse = try self.apiRequest.response(data: data)
//                    completionHandler(parsedResponse, nil)
//                } catch {
//                    completionHandler(nil, error)
//                }
//            }.resume()
//        } catch {
//            return completionHandler(nil, error)
//        }
//    }
//}
//
//
//class MockURLProtocol: URLProtocol {
//    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
//    override class func canInit(with request: URLRequest) -> Bool {
//        return true
//    }
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        return request
//    }
//    override func startLoading() {
//        guard let handler = MockURLProtocol.requestHandler else {
//            XCTFail("Received unexpected request with no handler set")
//            return
//        }
//        do {
//            let (response, data) = try handler(request)
//            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
//            client?.urlProtocol(self, didLoad: data)
//            client?.urlProtocolDidFinishLoading(self)
//        } catch {
//            client?.urlProtocol(self, didFailWithError: error)
//        }
//    }
//    
//    override func stopLoading() {
//    }
//}

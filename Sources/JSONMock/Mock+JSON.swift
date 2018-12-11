//
//  Mock+JSON.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/12/7.
//  Copyright © 2018 Yume. All rights reserved.
//

import Foundation
import enum YumeAlamofire.NetError

public class JSONMock : URLProtocol {
    public typealias FakeData = (data: Data, code: Int, header: [String:String])
    public typealias FakeJSON<T: Encodable> = (json: T, code: Int, header: [String:String])
    private static var fakes: [String: FakeData] = [:]
    
    public static func fake<T: Encodable>(url: String, res: FakeJSON<T>) throws {
        let res = (try res.json.encode(), res.code, res.header)
        self.fake(url: url, res: res)
    }

    public static func fake(url: String, res: FakeData) {
        self.fakes[url] = res
    }
    
    override public class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    var urlPath: String? {
        guard let url = request.url else { return nil }
        guard let scheme = url.scheme else { return nil }
        guard let host = url.host else { return nil }
        let port: String
        if let _port = url.port {
            port = ":" + String(_port)
        } else {
            port = ""
        }
        
        return scheme + "://" + host + port + url.path
    }
    
    var fakeResponse: HTTPURLResponse? {
        guard let url = request.url else { return nil }
        guard let urlPath = urlPath else { return nil }
        guard let fake = JSONMock.fakes[urlPath] else { return nil }
        return HTTPURLResponse(url: url, statusCode: fake.code, httpVersion: kCFHTTPVersion1_1 as String, headerFields: fake.header)
    }
    
    var fakeData: Data? {
        guard let urlPath = urlPath else { return nil }
        guard let fake = JSONMock.fakes[urlPath] else { return nil }
        return fake.data
    }
    
    override public func startLoading() {
//        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
//        let task = session.dataTask(with: self.request)
//        task.resume()
        guard let res = self.fakeResponse else {
            client?.urlProtocol(self, didFailWithError: NetError.unknown)
            return
        }
        
        guard let data = self.fakeData else {
            client?.urlProtocol(self, didFailWithError: NetError.unknown)
            return
        }
        
        // HTTPURLResponse()
        client?.urlProtocol(self, didReceive: res, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
        
//        task.resume()
    }

    override public func stopLoading() {
    }
}

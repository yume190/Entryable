//
//  Mock+JSON.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/12/7.
//  Copyright © 2018 Yume. All rights reserved.
//

import Foundation
#if !COCOAPODS
import enum YumeAlamofire.NetError
#endif

public class JSONMock: URLProtocol {

    private static var fakes: [String: Fake] = [:]
    public static func fake(url: String, fake: Fake) {
        self.fakes[url] = fake
    }

    override public class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    var urlPath: String? {
        guard let url: URL = request.url else { return nil }
        guard let scheme: String = url.scheme else { return nil }
        guard let host: String = url.host else { return nil }
        let port: String
        if let portString = url.port.map(String.init) {
            port = ":" + portString
        } else {
            port = ""
        }

        return scheme + "://" + host + port + url.path
    }

    var fake: Fake? {
        guard let urlPath: String = urlPath else { return nil }
        guard let fake: Fake = JSONMock.fakes[urlPath] else { return nil }
        return fake
    }

    override public func startLoading() {
        guard let fakes = self.fake?.get(request: self.request) else {
            client?.urlProtocol(self, didFailWithError: NetError.unknown)
            return
        }

        // HTTPURLResponse()
        client?.urlProtocol(self, didReceive: fakes.response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: fakes.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override public func stopLoading() {
    }
}

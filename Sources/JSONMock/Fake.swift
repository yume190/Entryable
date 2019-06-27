//
//  Fake.swift
//  JSONMock
//
//  Created by Yume on 2019/1/7.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public enum Fake {
    case data(data: Data, code: Int, header: [String: String])
    case json(json: Encodable, code: Int, header: [String: String])
    case request((_ request: URLRequest) -> (URLResponse, Data))
    
    func get(request: URLRequest) -> (response: URLResponse, data: Data)? {
        guard let url = request.url else { return nil }
        switch self {
        case let .data(data, code, header):
            guard let res = HTTPURLResponse(
                url: url,
                statusCode: code,
                httpVersion: kCFHTTPVersion1_1 as String,
                headerFields: header
                ) else { return nil }
            return (res, data)
        case let .json(json, code, header):
            guard let data = try? json.encode() else { return nil }
            guard let res = HTTPURLResponse(
                url: url,
                statusCode: code,
                httpVersion: kCFHTTPVersion1_1 as String,
                headerFields: header
                ) else { return nil }
            return (res, data)
        case let .request(req):
            return req(request)
        }
    }
}

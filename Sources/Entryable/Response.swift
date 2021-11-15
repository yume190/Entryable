//
//  Response.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/12/10.
//  Copyright © 2018 Yume. All rights reserved.
//

import Foundation

public struct Response<T> {
    public let data: T
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    
    public init(data: T, request: URLRequest? = nil, response: HTTPURLResponse?) {
        self.data = data
        self.request = request
        self.response = response
    }
    
    public func mapData<U>(transform: (T) throws -> U) rethrows -> Response<U> {
        return try Response<U>(
            data: transform(data),
            request: request,
            response: response
        )
    }
    
    public func map<U>(transform: (Response<T>) throws -> U) rethrows -> U {
        return try transform(self)
    }
}

//
//  HTTPRawResponse.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/12/10.
//  Copyright © 2018 Yume. All rights reserved.
//

import Foundation

public struct HTTPRawResponse<T> {
    public let data: T
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    
    public init(data: T, request: URLRequest? = nil, response: HTTPURLResponse?) {
        self.data = data
        self.request = request
        self.response = response
    }
    
    public func mapData<U>(transform: (T) throws -> U) rethrows -> HTTPRawResponse<U> {
        return try HTTPRawResponse<U>(
            data: transform(data),
            request: request,
            response: response
        )
    }
    
    public func mapData<U>(keyPath: KeyPath<T, U>) -> HTTPRawResponse<U> {
        return HTTPRawResponse<U>(
            data: self.data[keyPath: keyPath],
            request: request,
            response: response
        )
    }
    
    public func map<U>(transform: (HTTPRawResponse<T>) throws -> U) rethrows -> U {
        return try transform(self)
    }
    
    public func map<U>(keyPath: KeyPath<HTTPRawResponse<T>, U>) -> U {
        return self[keyPath: keyPath]
    }
}

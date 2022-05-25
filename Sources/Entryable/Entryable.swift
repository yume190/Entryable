//
//  Entryable.swift
//
//  Created by Yume on 2017/12/5.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation
import struct Alamofire.HTTPMethod
import struct Alamofire.HTTPHeaders
import class Alamofire.Session
import class Alamofire.DataRequest
import protocol Alamofire.URLConvertible

public protocol Entryable {
    associatedtype ResponseType
    
    associatedtype Parameters
    
    typealias Headers = [String: String]

    var entry: String { get }

    /// The HTTP method used in the request.
    var method: Alamofire.HTTPMethod { get }

    /// The headers to be used in the request.
    var headers: Headers { get }

    var parameters: Parameters? { get }

    var parameterType: ParameterType { get }
}

extension Entryable {
    public var method: Alamofire.HTTPMethod { return .get }
    public var headers: Headers { return [:] }
    public var parameters: Parameters? { return nil }
    public var parameterType: ParameterType { return .url }
}

public protocol DictionaryEntryable: Entryable where Parameters == [String : Any] {}
public protocol EncodeEntryable: Entryable where Parameters: Encodable {}

extension Entryable {
    public func client(_ client: Client) -> ClientBuilder<Self> {
        return client.builder(self)
    }
}

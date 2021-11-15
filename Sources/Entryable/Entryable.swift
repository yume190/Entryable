//
//  NetProtocol.swift
//  FlowerBus
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

    typealias Parameters = [String: Any] // Encodable?
    typealias Headers = [String: String]//Alamofire.HTTPHeaders

    var url: URLConvertible { get }

    var session: Alamofire.Session { get }

    /// The HTTP method used in the request.
    var method: Alamofire.HTTPMethod { get }

    /// The headers to be used in the request.
    var headers: Headers { get }

    var parameters: Parameters? { get }

    var parameterType: ParameterType { get }
}

extension Entryable {
    public var headers: Headers { return [:] }
    public var parameters: Parameters? { return nil }
    public var parameterType: ParameterType { return .url }
}

// where Self.Parameters == [String: Any]
extension Entryable {
    public var dataRequest: Alamofire.DataRequest {
        return session.request(
            self.url,
            method: self.method,
            parameters: self.parameters,
            encoding: self.parameterType.encoding,
            headers: HTTPHeaders(self.headers)
        )
    }
}

//extension Entryable where Self.Parameters: Encodable {
//    public var dataRequest: Alamofire.DataRequest {
//        return session.request(
//            self.url,
//            method: self.method,
//            parameters: self.parameters,
//            encoder: self.parameterType.encoder,
//            headers: HTTPHeaders(self.headers)
//        )
//    }
//}

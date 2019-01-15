//
//  NetProtocol.swift
//  FlowerBus
//
//  Created by Yume on 2017/12/5.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation
import enum Alamofire.HTTPMethod
import class Alamofire.SessionManager
import class Alamofire.DataRequest

import protocol Alamofire.URLConvertible
public protocol Entryable {
    associatedtype ResponseType

    typealias Parameters = [String: Any]
    typealias Headers = [String: String]

    var url: URLConvertible { get }

    var sessionManager: Alamofire.SessionManager { get }

    /// The HTTP method used in the request.
    var method: Alamofire.HTTPMethod { get }

    /// The headers to be used in the request.
    var headers: Headers { get }

    var parameters: Parameters { get }

    var parameterType: ParameterType { get }
}

extension Entryable {
    public var parameterType: ParameterType { return .url }

    public var dataRequest: Alamofire.DataRequest {
        return sessionManager.request(
            self.url,
            method: self.method,
            parameters: self.parameters,
            encoding: self.parameterType.encoder,
            headers: self.headers
        )
    }
}

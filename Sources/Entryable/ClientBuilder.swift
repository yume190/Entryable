//
//  ClientBuilder.swift
//
//
//  Created by Yume on 2022/3/30.
//

import Foundation
import class Alamofire.DataRequest
import struct Alamofire.HTTPHeaders

public struct ClientBuilder<Request: Entryable> {
    public let client: Client
    public let request: Request
    public let headers: [String: String]
    
    public var mergedHeaders: [String: String] {
        headers.merging(self.request.headers) { first, _ in
            return first
        }
    }
    
    internal init(client: Client, request: Request, headers: [String: String] = [:]) {
        self.client = client
        self.request = request
        self.headers = headers
    }
    
    public func header(_ key: String, _ value: String) -> ClientBuilder<Request> {
        var headers = self.headers
        headers[key] = value
        return .init(client: client, request: request, headers: headers)
    }
}

extension ClientBuilder where Request: Entryable {
    private func _build() -> Alamofire.DataRequest {
        return client.session.request(
            self.client.base.appendingPathComponent(self.request.entry),
            method: self.request.method,
            parameters: nil,
            encoding: self.request.parameterType.encoding,
            headers: HTTPHeaders(self.mergedHeaders),
            interceptor: self.request.interceptor
        )
    }
    
    public func build() -> Entry<Request.ResponseType> {
        return .init(_build())
    }
}

extension ClientBuilder where Request: DictionaryEntryable {
    private func _build() -> Alamofire.DataRequest {
        return client.session.request(
            self.client.base.appendingPathComponent(self.request.entry),
            method: self.request.method,
            parameters: self.request.parameters,
            encoding: self.request.parameterType.encoding,
            headers: HTTPHeaders(self.mergedHeaders),
            interceptor: self.request.interceptor
        )
    }
    
    public func build() -> Entry<Request.ResponseType> {
        return .init(_build())
    }
}

extension ClientBuilder where Request: EncodeEntryable {
    private func _build() -> Alamofire.DataRequest {
        return client.session.request(
            self.client.base.appendingPathComponent(self.request.entry),
            method: self.request.method,
            parameters: self.request.parameters,
            encoder: self.request.parameterType.encoder,
            headers: HTTPHeaders(self.mergedHeaders),
            interceptor: self.request.interceptor
        )
    }
    
    public func build() -> Entry<Request.ResponseType> {
        return .init(_build())
    }
}

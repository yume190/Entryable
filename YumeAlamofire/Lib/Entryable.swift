//
//  NetProtocol.swift
//  FlowerBus
//
//  Created by Yume on 2017/12/5.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation
import Alamofire
import JSONDecodeKit

public protocol SimpleEntryable {
    
    typealias Parameters = [String : Any]
    typealias Headers = [String : String]
    
    /// The target's base `URL`.
    var base: String { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    var url: String { get }
    
    /// The HTTP method used in the request.
    var method: Alamofire.HTTPMethod { get }
    
    /// The headers to be used in the request.
    var headers: Headers { get }
    
    var parameters: Parameters { get }
    
    var isJSONRequest: Bool { get }
    
    var request:Alamofire.DataRequest { get }
}

extension SimpleEntryable {
    public var url: String {
        return base + path
    }
    
    public var request:Alamofire.DataRequest {
        if isJSONRequest {
            return jsonRequest
        } else {
            return normalRequest
        }
    }
    
    public var normalRequest: Alamofire.DataRequest {
        return Alamofire.request(url, method: method, parameters: parameters, headers: headers)
    }
    
    public var jsonRequest: Alamofire.DataRequest {
        let url = URL(string: self.url)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: self.parameters, options: [])
        } catch {
            // No-op
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return Alamofire.request(urlRequest)
    }    
}

public protocol Entryable:SimpleEntryable {
    associatedtype ResponseType : JSONDecodable
    func req(failureHandler: ((Alamofire.DefaultDataResponse) -> Void)?, successHandler: ((ResponseType) -> Void)?)
}

extension Entryable {
    public func req(failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil, successHandler: ((ResponseType) -> Void)?) {
        YumeAlamofire.requestSingle(entry: self, failureHandler: failureHandler, successHandler: successHandler)
    }
}

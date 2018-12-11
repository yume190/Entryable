////
////  Requestable.swift
////  YumeAlamofire
////
////  Created by Yume on 2018/12/10.
////  Copyright © 2018 Yume. All rights reserved.
////
//
//import Foundation
//import class Alamofire.SessionManager
//import class Alamofire.DataRequest
//
//public protocol Requestable {
//    associatedtype Entry: Entryable
//
//    var entry: Entry { get }
//    var sessionManager: Alamofire.SessionManager { get }
//
//    var dataRequest: Alamofire.DataRequest { get }
//}
//
//extension Requestable {
//    public var dataRequest: Alamofire.DataRequest {
//        return sessionManager.request(
//            self.entry.url,
//            method: self.entry.method,
//            parameters: self.entry.parameters,
//            encoding: self.entry.requestType.encoder,
//            headers: self.entry.headers
//        )
//    }
//}

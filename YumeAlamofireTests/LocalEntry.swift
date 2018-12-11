//
//  Entry+A.swift
//  GenericRequest
//
//  Created by Yume on 2018/6/6.
//

import Foundation
import YumeAlamofire
import Alamofire

struct Entry {
    static let base = "http://127.0.0.1:3000"
    
    public static let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15 // seconds
        configuration.timeoutIntervalForResource = 15
        configuration.urlCache = nil
        return SessionManager(configuration: configuration)
    }()
}


extension Entry {
    struct A: Entryable {
        typealias ResponseType = Response
        
        let key: String
        init(key: String) {
            self.key = key
        }
        
        let base: String = Entry.base
        var path: String { return "/yume" }
        let sessionManager: SessionManager = Entry.sessionManager
        let method: Alamofire.HTTPMethod = .get
        let parameters: Parameters = ["a":"b"]
        let isJSONRequest: Bool = false
        var headers: Headers {
            return ["key" : key]
        }
    }
}

extension Entry.A {
    public struct Response: Codable, Equatable {
        let code: Int
        let message: String
    }
}


extension Entry {
    struct B: Entryable {
        typealias ResponseType = Void
        
        let key: String
        init(key: String) {
            self.key = key
        }
        
        let base: String = Entry.base
        var path: String { return "/yume" }
        let sessionManager: SessionManager = Entry.sessionManager
        let method: Alamofire.HTTPMethod = .head
        let parameters: Parameters = [:]
        let isJSONRequest: Bool = false
        var headers: Headers {
            return ["key" : key]
        }
    }
}

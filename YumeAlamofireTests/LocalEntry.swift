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
    
    public static let alamofire:SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15 // seconds
        configuration.timeoutIntervalForResource = 15
        configuration.urlCache = nil
        let alamofire = Alamofire.SessionManager(configuration: configuration)
        return alamofire
    }()
}


extension Entry {
    struct A: Entryable {
        typealias ResponseType = Response
        
        let key: String
        
        let base: String = Entry.base
        var path: String { return "/yume" }
        let sessionManager: Alamofire.SessionManager = Entry.alamofire
        let method: Alamofire.HTTPMethod = .get
        let parameters: Parameters = [:]
        let isJSONRequest: Bool = false
        var headers: Headers {
            return ["key" : key]
        }
    }
}

extension Entry.A {
    struct Response: Codable {
        let code: Int
        let message: String
    }
}

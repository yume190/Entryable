//
//  Entry+A.swift
//  GenericRequest
//
//  Created by Yume on 2018/6/6.
//

import Foundation
import Entryable
import Alamofire
import RxSwift
import RxRelay
import JSONMock

struct Entry {
    static let base = "http://127.0.0.1:3000"
    
    public static let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15 // seconds
        configuration.timeoutIntervalForResource = 15
        configuration.urlCache = nil
        return Session(configuration: configuration, requestQueue: DispatchQueue.global(qos: .background))
//        return Session(configuration: configuration)
    }()
}

extension Entry {
    struct A: EncodeEntryable {
        typealias ResponseType = Response
        
        public struct Parameters: Encodable {
            let a: String
        }
        
        let key: String
        
        let url: URLConvertible = Entry.base + "/yume"
        let session: Session = Entry.session
        let method: Alamofire.HTTPMethod = .get
        let parameters: Parameters? = Parameters(a: "b")
        let parameterType: ParameterType = .url
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
    struct B: DictionaryEntryable {
        typealias ResponseType = Void
        
        let key: String
        init(key: String) {
            self.key = key
        }
        
        let url: URLConvertible = Entry.base + "/yume"
        let session: Session = Entry.session
        let method: Alamofire.HTTPMethod = .head
        let parameters: Parameters? = [:]
        var headers: Headers {
            return ["key" : key]
        }
    }
}

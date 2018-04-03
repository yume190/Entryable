////
////  Entry+BaseDatas.swift
////  FlowerBus
////
////  Created by Yume on 2017/12/12.
////  Copyright © 2017年 Yume. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import JSONDecodeKit
//@testable import YumeAlamofire
//
//struct Entry {}
//
//extension Entry {
//    struct BaseDatas:Entryable {
//        typealias ResponseType = Response
//        
//        let base: String = "http://localhost:3000"
//        var path:String { return "/yume" }
//        let method: Alamofire.HTTPMethod = .get
//        let parameters:Parameters = [:]
//        let isJSONRequest: Bool = false
//        let headers:Headers = [:]
//    }
//}
//
//extension Entry.BaseDatas {
//    struct Response {
//        let code: Int
//        let message: String
//    }
//}
//
//extension Entry.BaseDatas.Response: JSONDecodable {
//    static func decode(json: JSON) throws -> Entry.BaseDatas.Response {
//        return try Entry.BaseDatas.Response(code: json <| "code", message: json <| "message")
//    }
//}
//

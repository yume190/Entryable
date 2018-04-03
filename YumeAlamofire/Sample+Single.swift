//
//  Entry+BaseDatas.swift
//  FlowerBus
//
//  Created by Yume on 2017/12/12.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation
import Alamofire
import JSONDecodeKit

struct Entry {}

extension Entry {
    struct BaseDatas: Entryable {
        typealias ResponseType = Response

        let key: String

        let base: String = ""
        var path: String { return "/basedatas/\(key)" }
        let sessionManager: Alamofire.SessionManager = Alamofire.SessionManager.default
        let method: Alamofire.HTTPMethod = .get
        let parameters: Parameters = [:]
        let isJSONRequest: Bool = false
        let headers: Headers = [:]
    }
}

extension Entry.BaseDatas {
    struct Response {
        let code: Int
        let message: String
    }
}

extension Entry.BaseDatas.Response: JSONDecodable {
    static func decode(json: JSON) throws -> Entry.BaseDatas.Response {
        return try Entry.BaseDatas.Response(code: json <| "code", message: json <| "message")
    }
}



func abc() {
    Entry.BaseDatas(key: "").req { (res) in
        print(res.code)
    }
    
    Entry.BaseDatas2(key: "").req { (res) in
        print(res.code)
    }
    
    Entry.BaseDatas3(key: "").req { (res) in
        print(res[0].code)
    }
}

//
//  Sample+Codable.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/3/30.
//  Copyright © 2018年 Yume. All rights reserved.
//

import Foundation
import Alamofire

extension Entry {
    struct BaseDatas2: Entryable {
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

extension Entry.BaseDatas2 {
    struct Response: Codable {
        let code: Int
        let message: String
    }
}

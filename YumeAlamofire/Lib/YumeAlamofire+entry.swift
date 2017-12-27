//
//  YumeAlamofire.swift
//  FlowerBus
//
//  Created by Yume on 2017/12/5.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation
import Alamofire

extension YumeAlamofire {
    public enum Entry:Entryable {
        typealias ResponseType = String
        
        case custom(url:String)
        
        var base: String {
            switch self {
            case .custom(let url): return url
            }
        }
        var path:String { return ""}
        var method: Alamofire.HTTPMethod { return .get }
        var parameters:Parameters { return [:] }
        var isJSONRequest: Bool { return false }
        var headers:Headers { return [:] }
    }
}

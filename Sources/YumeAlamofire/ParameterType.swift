//
//  RequestType.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/12/10.
//  Copyright © 2018 Yume. All rights reserved.
//

import Foundation

import struct Alamofire.URLEncoding
import struct Alamofire.JSONEncoding
import struct Alamofire.PropertyListEncoding
import protocol Alamofire.ParameterEncoding

public enum ParameterType {
    case url
    case json
    case propertyList
    case custom(ParameterEncoding)

    public var encoder: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        case .propertyList: return PropertyListEncoding.default
        case .custom(let encoder): return encoder
        }
    }
}

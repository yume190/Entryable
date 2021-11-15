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

//import class Alamofire.URLEncodedFormParameterEncoder
//import class Alamofire.JSONParameterEncoder

import protocol Alamofire.ParameterEncoding
import protocol Alamofire.ParameterEncoder

public enum ParameterType {
    case url
    case json
    case custom(ParameterEncoding) //, ParameterEncoder)

    public var encoding: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        case .custom(let encoding): return encoding
        }
    }
    
//    public var encoder: ParameterEncoder {
//        switch self {
//        case .url: return JSONParameterEncoder.default
//        case .json: return URLEncodedFormParameterEncoder.default
//        case .custom(_, let encoder): return encoder
//        }
//    }
}

//
//  Alamofire+JSONDecodeKIT.swift
//  BusApp
//
//  Created by Yume on 2017/2/2.
//  Copyright © 2017年 Yume. All rights reserved.

import Foundation
import protocol JSONDecodeKit.JSONDecodable
import struct JSONDecodeKit.JSON
import struct Alamofire.DefaultDataResponse

internal func guardData(res: DefaultDataResponse) -> (response: HTTPURLResponse, data: Data)? {
    guard
        let response: HTTPURLResponse = res.response,
        let data: Data = res.data else {
        print("API (\(res.request?.url?.absoluteString ?? "")): No Response.")
        return nil
    }
    return (response:response, data:data)
}

public struct YumeAlamofire {}

// MARK: Debug Info
extension YumeAlamofire {
    public typealias DebugInfoFunction = (_ data: Data?) -> Swift.Void
    public static func emptyDebugInfo(data: Data?) {}
    public static func basicDebugInfo(data: Data?) {
        guard let data: Data = data else { return }
        print("The error response : \(String.init(data: data, encoding: .utf8) ?? "")")
    }
}

extension YumeAlamofire {
    internal static func parseErrorHandle<OutputType>(type: OutputType.Type, url: URL?, error: Error) {
        let parseError: String = [
            "API Data Parse Error.",
            "Type : \(OutputType.self)",
            "Url : \(url?.path ?? "")"
            ].joined(separator: "\n")
        print(parseError)
        print("-----------------")
        print(error)
    }
}

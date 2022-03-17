//
//  NetError.swift
//  
//
//  Created by Yume on 2022/3/17.
//

import Foundation

public enum NetError: Error, CustomStringConvertible {
    case url(URL?, Data, Error)
    public var description: String {
        switch self {
        case let .url(url, data, error): return """
        [NET ERROR]
        URL:
        \(url ?? URL(fileURLWithPath: ""))
        Data:
        \(String.init(data: data, encoding: .utf8) ?? "")
        Error:
        \(error)
        """
        }
    }
}

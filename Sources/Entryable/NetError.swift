//
//  NetError.swift
//  
//
//  Created by Yume on 2022/3/17.
//

import Foundation

public private(set) var isShowDetailError: Bool = false
public func setup(isShowDetailError isShow: Bool) {
    isShowDetailError = isShow
}

public enum NetError: Error, CustomStringConvertible {
    case url(HTTPRawResponse<Data>, Error)
    
    public var description: String {
        switch self {
        case let .url(raw, error):
            guard isShowDetailError else {
                return "\(error)"
            }
            
            return """
            [NET ERROR]
            request:
                url: \(raw.request?.url?.description ?? "")
                method: \(raw.request?.method?.rawValue ?? "")
                header: \(raw.request?.headers.description ?? "")
                body: \(raw.request?.httpBody?.utf8 ?? "")
            response:
                header: \(raw.response?.headers.description ?? "")
                body: \(raw.data.utf8 ?? "")
            error: \(error)
            """
        }
    }
}

extension Data {
    var utf8: String? {
        return String(data: self, encoding: .utf8)
    }
}

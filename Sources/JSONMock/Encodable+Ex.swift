//
//  Encodable+Ex.swift
//  JSONMock
//
//  Created by Yume on 2018/12/11.
//  Copyright © 2018 Yume. All rights reserved.
//

#if !COCOAPODS
import Foundation

extension Encodable {
    internal static func encode<T: Encodable>(data: T, encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(data)
    }

    internal func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try Self.encode(data: self, encoder: encoder)
    }
}
#endif

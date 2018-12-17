//
//  Codable+Ex.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/12/10.
//  Copyright © 2018 Yume. All rights reserved.
//

import Foundation

extension Decodable {
    static func decode(data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try Self.decodeGeneric(data: data, decoder: decoder)
    }

    static func decodeGeneric<T: Decodable>(data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
}

extension Encodable {
    static func encode<T: Encodable>(data: T, encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(data)
    }

    func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try Self.encode(data: self, encoder: encoder)
    }
}

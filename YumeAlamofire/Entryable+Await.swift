//
//  Entryable+Await.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/12/5.
//  Copyright © 2018 Yume. All rights reserved.
//

import Foundation
import PromiseKit
import AwaitKit
import JSONDecodeKit

extension Entryable {
    public func awaitData() throws -> Data {
        return try AwaitKit.await(self.promiseData)
    }
}

extension Entryable where ResponseType : JSONDecodable {
    public func await() throws -> ResponseType {
        return try AwaitKit.await(self.promise)
    }
}

extension Entryable where ResponseType : Codable {
    public func await() throws -> ResponseType {
        return try AwaitKit.await(self.promise)
    }
}

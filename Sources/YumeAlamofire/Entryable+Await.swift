//
//  Entryable+Await.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/6/6.
//  Copyright © 2018年 Yume. All rights reserved.
//

import Foundation
import PromiseKit
import AwaitKit
import JSONDecodeKit

extension Entryable {
    public var promiseData: Promise<Data> {
        return Promise<Data> { (seal) in
            self.dataRequest.responseData { (res) in
                if let data = res.result.value {
                    seal.fulfill(data)
                } else {
                    seal.reject(
                        res.error ??
                        NSError(domain: "no network response data", code: 0, userInfo: nil)
                    )
                }
            }
        }
    }
}

extension Entryable where ResponseType: Codable {
    public var promise: Promise<ResponseType> {
        return self.promiseData.map { (data) throws -> ResponseType in
            try JSONDecoder().decode(ResponseType.self, from: data)
        }
    }
}

extension Entryable where ResponseType: JSONDecodable {
    public var promise: Promise<ResponseType> {
        return self.promiseData.map { (data) throws -> ResponseType in
            try ResponseType.decode(json: JSON(data: data))
        }
    }
}

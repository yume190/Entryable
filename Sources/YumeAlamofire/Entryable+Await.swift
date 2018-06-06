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

extension Entryable where ResponseType: Codable {
    var promise: Promise<ResponseType> {
        return Promise<ResponseType> { (seal) in
            // Make an HTTP request to download the image.
            self.dataRequest.responseData { (res) in
                let decoder = JSONDecoder()
                
                if let data = res.result.value {
                    do {
                        let result = try decoder.decode(ResponseType.self, from: data)
                        seal.fulfill(result)
                    } catch {
                        seal.reject(error)
                    }
                } else {
                    seal.reject(res.error ?? NSError(domain: "no response data", code: 0, userInfo: nil))
                }
            }
        }
    }
}

extension Entryable where ResponseType: JSONDecodable {
    var promise: Promise<ResponseType> {
        return Promise<ResponseType> { (seal) in
            // Make an HTTP request to download the image.
            self.dataRequest.responseData { (res) in
                if let data = res.result.value {
                    do {
                        let result = try ResponseType.decode(json: JSON(data: data))
                        seal.fulfill(result)
                    } catch {
                        seal.reject(error)
                    }
                } else {
                    seal.reject(res.error ?? NSError(domain: "no response data", code: 0, userInfo: nil))
                }
            }
        }
    }
}

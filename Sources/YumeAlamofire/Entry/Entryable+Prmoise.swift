//
//  Entryable+Await.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/6/6.
//  Copyright © 2018年 Yume. All rights reserved.
//

import Foundation
import class PromiseKit.Promise
import protocol JSONDecodeKit.JSONDecodable
import struct JSONDecodeKit.JSON

extension Entryable {
    public var promiseData: Promise<Response<Data>> {
        return Promise<Response<Data>> { (seal) in
            self.dataRequest.responseData { (res) in
                let error = res.error ?? NetError.unknown
                guard let data = res.data else { return seal.reject(error) }
                guard let request = res.request else { return seal.reject(error) }
                guard let response = res.response else { return seal.reject(error) }

                let result = Response<Data>(
                    data: data,
                    request: request,
                    response: response
                )
                return seal.fulfill(result)
            }
        }
    }

    public var promiseVoid: Promise<Response<Void>> {
        return Promise<Response<Void>> { (seal) in
            self.dataRequest.responseData { (res) in
                let error = res.error ?? NetError.unknown
//                guard let data = res.data else { seal.reject(error) }
                guard let request = res.request else { return seal.reject(error) }
                guard let response = res.response else { return seal.reject(error) }

                let result = Response<Void>(
                    data: (),
                    request: request,
                    response: response
                )
                return seal.fulfill(result)
            }
        }
    }
}

extension Entryable where ResponseType: Codable {
    public var promise: Promise<Response<ResponseType>> {
        return self.promiseData.map { (response) throws -> Response<ResponseType> in
            let data = try ResponseType.decode(data: response.data)
            return Response<ResponseType>(
                data: data,
                request: response.request,
                response: response.response
            )
        }
    }
}

extension Entryable where ResponseType: JSONDecodable {
    public var promise: Promise<Response<ResponseType>> {
        return self.promiseData.map { (response) throws -> Response<ResponseType> in
            let data = try ResponseType.decode(json: JSON(data: response.data))
            return Response<ResponseType>(
                data: data,
                request: response.request,
                response: response.response
            )
        }
    }
}

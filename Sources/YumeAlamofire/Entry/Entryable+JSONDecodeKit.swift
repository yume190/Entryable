//
//  Entryable+Single.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/3/26.
//  Copyright © 2018年 Yume. All rights reserved.
//

import Foundation
import protocol JSONDecodeKit.JSONDecodable
import struct JSONDecodeKit.JSON
import struct Alamofire.DefaultDataResponse
import class Alamofire.DataRequest

extension Entryable where ResponseType: JSONDecodable {

    // swiftlint:disable:next line_length
    public func req(failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil, successHandler: ((ResponseType) -> Void)?) {
        Self.request(entry: self, failureHandler: failureHandler, successHandler: successHandler)
    }

    private static func decodeAsSingle<OutputType: JSONDecodable>(data: Data) throws -> OutputType {
        return try OutputType.decode(json: JSON(data: data, isTraceKeypath: true))
    }

    public static func request(
        entry: Self,
        responseInfo: @escaping YumeAlamofire.DebugInfoFunction = YumeAlamofire.basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: ((ResponseType) -> Void)?) {

        self.request(
            dataRequeset: entry.dataRequest,
            responseInfo: responseInfo,
            failureHandler: failureHandler,
            successHandler: successHandler
        )
    }

    public static func request<OutputType: JSONDecodable>(
        dataRequeset: Alamofire.DataRequest,
        responseInfo: @escaping YumeAlamofire.DebugInfoFunction = YumeAlamofire.basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: ((OutputType) -> Void)?) {
        dataRequeset.response { res in
            guard let target = guardData(res: res) else {
                failureHandler?(res)
                return
            }
            do {
                try successHandler?(Self.decodeAsSingle(data: target.data))
            } catch {
                failureHandler?(res)
                YumeAlamofire.parseErrorHandle(type: OutputType.self, url: res.request?.url, error: error)
            }
        }
    }
}

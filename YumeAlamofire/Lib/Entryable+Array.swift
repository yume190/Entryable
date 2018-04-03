//
//  Entryable+Array.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/3/26.
//  Copyright © 2018年 Yume. All rights reserved.
//

import Foundation
import JSONDecodeKit
import Alamofire

extension Entryable where ResponseType: Sequence, ResponseType.Element: JSONDecodable {
    func req(failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil, successHandler: (([ResponseType.Element]) -> Void)?) {

        Self.request(entry: self, failureHandler: failureHandler, successHandler: successHandler)
    }

    private static func decodeAsArray<OutputType:JSONDecodable>(data:Data) throws -> [OutputType] {
        return try JSON(data: data,isTraceKeypath:true).array()
    }

    public static func request(
        entry: Self,
        responseInfo: @escaping YumeAlamofire.DebugInfoFunction = YumeAlamofire.basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: (([ResponseType.Element]) -> Void)?) {

        request(
            dataRequeset: entry.dataRequest,
            responseInfo: responseInfo,
            failureHandler: failureHandler,
            successHandler: successHandler
        )
    }
    
    public static func request<OutputType:JSONDecodable>(
        dataRequeset:Alamofire.DataRequest,
        responseInfo:@escaping YumeAlamofire.DebugInfoFunction = YumeAlamofire.basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: (([OutputType]) -> Void)?) {
        dataRequeset.response {
            res in
            guard let target = guardData(res: res) else {
                failureHandler?(res)
                return
            }
            do {
                try successHandler?(decodeAsArray(data: target.data))
            } catch {
                failureHandler?(res)
                YumeAlamofire.parseErrorHandle(type: OutputType.self, url: res.request?.url, error: error)
            }
        }
    }
}

//
//  Entryable+Codable.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/3/30.
//  Copyright © 2018年 Yume. All rights reserved.
//

import Foundation
import Alamofire

extension Entryable where ResponseType: Codable {
    
    func req(failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil, successHandler: ((ResponseType) -> Void)?) {
        Self.request(entry: self, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    public static func request(
        entry: Self,
        responseInfo: @escaping YumeAlamofire.DebugInfoFunction = YumeAlamofire.basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: ((ResponseType) -> Void)?) {
        
        request(
            dataRequeset: entry.dataRequest,
            responseInfo: responseInfo,
            failureHandler: failureHandler,
            successHandler: successHandler
        )
    }
    
    public static func request<OutputType: Codable>(
        dataRequeset: Alamofire.DataRequest,
        responseInfo: @escaping YumeAlamofire.DebugInfoFunction = YumeAlamofire.basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: ((OutputType) -> Void)?) {
        dataRequeset.response {
            res in
            guard let target = guardData(res: res) else {
                failureHandler?(res)
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(OutputType.self, from: target.data)
                successHandler?(result)
            } catch {
                failureHandler?(res)
                YumeAlamofire.parseErrorHandle(type: OutputType.self, url: res.request?.url, error: error)
            }
        }
    }
}

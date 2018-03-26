//
//  Alamofire+JSONDecodeKIT.swift
//  BusApp
//
//  Created by Yume on 2017/2/2.
//  Copyright © 2017年 Yume. All rights reserved.

import Foundation
import JSONDecodeKit
import Alamofire

public struct YumeAlamofire {}

// MARK: Debug Info
extension YumeAlamofire {
    public typealias DebugInfoFunction = (_ data:Data?) -> Swift.Void
    public static func emptyDebugInfo(data:Data?) {}
    public static func basicDebugInfo(data:Data?) {
        guard let data = data else { return }
        print("The error response : \(String.init(data: data, encoding: .utf8) ?? "")")
    }
}

// MARK: Decode data
extension YumeAlamofire {
    private static func decodeAsSingle<OutputType:JSONDecodable>(data:Data) throws -> OutputType {
        return try OutputType.decode(json: JSON(data: data,isTraceKeypath:true))
    }
    
    private static func decodeAsArray<OutputType:JSONDecodable>(data:Data) throws -> [OutputType] {
        return try JSON(data: data,isTraceKeypath:true).array()
    }
}

extension YumeAlamofire {
    private static func parseErrorHandle<OutputType:JSONDecodable>(type:OutputType.Type, url:URL?, error:Error) {
        let parseError = [
            "API Data Parse Error.",
            "Type : \(OutputType.self)",
            "Url : \(url?.path ?? "")"
            ].joined(separator: "\n")
        print(parseError)
        print("-----------------")
        print(error)
    }
}

extension YumeAlamofire {
    private static func guardData(res:DefaultDataResponse) -> (response:HTTPURLResponse,data:Data)? {
        guard let response = res.response,let data = res.data else {
            print("API (\(res.request?.url?.absoluteString ?? "")): No Response.")
            return nil
        }
        return (response:response,data:data)
    }
    
    public static func requestSingle<OutputType:JSONDecodable>(
        dataRequeset:Alamofire.DataRequest,
        responseInfo:@escaping DebugInfoFunction = YumeAlamofire.basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: ((OutputType) -> Void)?) {
        dataRequeset.response {
            res in
            guard let target = guardData(res: res) else {
                failureHandler?(res)
                return
            }
            
            do {
                try successHandler?(self.decodeAsSingle(data:target.data))
            } catch {
                failureHandler?(res)
                parseErrorHandle(type: OutputType.self, url: res.request?.url, error: error)
            }
        }
    }
    
    public static func requestSingle<Entry: SingleEntryable>(
        entry:Entry,
        responseInfo:@escaping DebugInfoFunction = YumeAlamofire.basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: ((Entry.ResponseType) -> Void)?) {
        
        YumeAlamofire.requestSingle(
            dataRequeset: entry.request,
            responseInfo: responseInfo,
            failureHandler: failureHandler,
            successHandler: successHandler
        )
    }
    
    public static func requestArray<OutputType:JSONDecodable>(
        dataRequeset:Alamofire.DataRequest,
        responseInfo:@escaping DebugInfoFunction = basicDebugInfo,
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
                parseErrorHandle(type: OutputType.self, url: res.request?.url, error: error)
            }
        }
    }
    
    public static func requestArray<Entry: ArrayEntryable>(
        entry:Entry,
        responseInfo:@escaping DebugInfoFunction = basicDebugInfo,
        failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil,
        successHandler: (([Entry.ResponseType]) -> Void)?) {
        
        requestArray(
            dataRequeset:entry.request,
            responseInfo:responseInfo,
            failureHandler: failureHandler,
            successHandler: successHandler
        )
    }
}

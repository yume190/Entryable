//
//  Entryable+Single.swift
//  YumeAlamofire
//
//  Created by Yume on 2018/3/26.
//  Copyright © 2018年 Yume. All rights reserved.
//

import Foundation
import JSONDecodeKit
import Alamofire

public protocol SingleEntryable: SimpleEntryable {
    associatedtype ResponseType : JSONDecodable
    func req(failureHandler: ((Alamofire.DefaultDataResponse) -> Void)?, successHandler: ((ResponseType) -> Void)?)
}

extension SingleEntryable {
    public func req(failureHandler: ((Alamofire.DefaultDataResponse) -> Void)? = nil, successHandler: ((ResponseType) -> Void)?) {
        YumeAlamofire.requestSingle(entry: self, failureHandler: failureHandler, successHandler: successHandler)
    }
}

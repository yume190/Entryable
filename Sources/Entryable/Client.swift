//
//  Client.swift
//
//
//  Created by Yume on 2022/3/29.
//

import Foundation
import class Alamofire.Session

private enum URLError: Error {
    case invalid
}

public struct Client {
    public let base: URL
    public let session: Session
    
    public init(_ base: URL, _ session: Session) {
        self.base = base
        self.session = session
    }
    
    public init(_ base: String, _ session: Session) throws {
        guard let url = URL(string: base) else {
            throw URLError.invalid
        }
        self.init(url, session)
    }
    
    public func builder<Request: Entryable>(_ request: Request) -> ClientBuilder<Request> {
        return .init(client: self, request: request)
    }
}

//
//  File.swift
//  
//
//  Created by Yume on 2021/11/11.
//

import Foundation

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Entryable {
    public func fetchData() async throws -> HTTPRawResponse<Data> {
        let request = self.dataRequest
        
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                request.validate().responseData { (res) in
                    let result = res.result.map { data in
                        return HTTPRawResponse(data: data, request: res.request, response: res.response)
                    }
                    continuation.resume(with: result)
                }
            }
        } onCancel: {
            request.cancel()
        }
    }
    
    public var rawData: HTTPRawResponse<Data> {
        get async throws {
            try await self.fetchData()
        }
    }
    
    public var data: Data {
        get async throws {
            try await self.rawData.data
        }
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Entryable where ResponseType: Codable {
    public func fetch(decoder: JSONDecoder = JSONDecoder()) async throws -> HTTPRawResponse<ResponseType> {
        return try await self.fetchData()
            .mapData{ data in
                return try ResponseType.decode(data: data, decoder: decoder)
            }
    }
    
    public var rawValue: HTTPRawResponse<ResponseType> {
        get async throws {
            try await self.fetch()
        }
    }
    
    public var value: ResponseType {
        get async throws {
            try await self.rawValue.data
        }
    }
}

//Showing Recent Messages
//Undefined symbol: default argument 0 of (extension in Entryable):Entryable.Entryable< where A.ResponseType: Swift.Decodable, A.ResponseType: Swift.Encodable>.fetch(decoder: Foundation.JSONDecoder) async throws -> Entryable.HTTPRawResponse<A.ResponseType>


//{ get async throws }

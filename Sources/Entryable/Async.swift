//
//  File.swift
//  
//
//  Created by Yume on 2021/11/11.
//

import Foundation

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension Entryable {
    func fetchData() async throws -> HTTPRawResponse<Data> {
        return try await withCheckedThrowingContinuation { continuation in
            self.dataRequest.validate().responseData { (res) in
                let result = res.result.map { data in
                    return HTTPRawResponse(data: data, request: res.request, response: res.response)
                }
                continuation.resume(with: result)
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension Entryable where ResponseType: Codable {
    func fetch(decoder: JSONDecoder = JSONDecoder()) async throws -> HTTPRawResponse<ResponseType> {
        return try await self.fetchData()
            .mapData{ data in
                return try ResponseType.decode(data: data, decoder: decoder)
            }
    }
}

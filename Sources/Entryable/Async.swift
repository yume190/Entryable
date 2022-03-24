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
        return try await withCheckedThrowingContinuation { continuation in
            self.dataRequest.validate().responseData { (res) in
                let result = res.result.map { data in
                    return HTTPRawResponse(data: data, request: res.request, response: res.response)
                }
                continuation.resume(with: result)
            }
        }
    }
    
    public var taskData: Task<HTTPRawResponse<Data>, Error> {
        return Task {
            return try await self.fetchData()
        }
    }
    
    public var resultData: Result<HTTPRawResponse<Data>, Error> {
        get async {
             await self.taskData.result
        }
    }
    
    public var valueData: HTTPRawResponse<Data> {
        get async throws {
             try await self.taskData.value
        }
    }
    
    func test() async {
        
//        withThrowingTaskGroup(of: Void.self) { group in
//            group.addTask(priority: .high, operation: <#T##() async throws -> Void#>)
//        }
        
        do {
            let v: HTTPRawResponse<Data> = try await self.valueData
            print(v)
        } catch {
            print(error)
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
    
    public var task: Task<HTTPRawResponse<ResponseType>, Error> {
        return Task {
            return try await self.fetch()
        }
    }
    
    public var result: Result<HTTPRawResponse<ResponseType>, Error> {
        get async {
             await self.task.result
        }
    }
    
    public var value: HTTPRawResponse<ResponseType> {
        get async throws {
             try await self.task.value
        }
    }
}

//Showing Recent Messages
//Undefined symbol: default argument 0 of (extension in Entryable):Entryable.Entryable< where A.ResponseType: Swift.Decodable, A.ResponseType: Swift.Encodable>.fetch(decoder: Foundation.JSONDecoder) async throws -> Entryable.HTTPRawResponse<A.ResponseType>


//{ get async throws }

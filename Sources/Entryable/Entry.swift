import Foundation
import class Alamofire.DataRequest

public struct Entry<ResponseType> {
    public let request: Alamofire.DataRequest
    public init(_ request: Alamofire.DataRequest) {
        self.request = request
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Entry {
    public func fetchRawResponseData() async throws -> HTTPRawResponse<Data> {
        let request = self.request
        
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
    
    public func fetchData() async throws -> Data {
        return try await self.fetchRawResponseData().data
    }
    
//    public var rawData: HTTPRawResponse<Data> {
//        get async throws {
//            try await self.fetchData()
//        }
//    }
    public var data: Data {
        get async throws {
            try await self.fetchData()
        }
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Entry where ResponseType: Codable {
    public func fetchRawResponse(decoder: JSONDecoder = JSONDecoder()) async throws -> HTTPRawResponse<ResponseType> {
        return try await self.fetchRawResponseData()
            .mapData{ data in
                do {
                    return try ResponseType.decode(data: data, decoder: decoder)
                } catch {
                    throw NetError.url(
                        try? self.request.convertible.asURLRequest().url,
                        data,
                        error
                    )
                }
            }
    }
    
    public func fetch(decoder: JSONDecoder = JSONDecoder()) async throws -> ResponseType {
        return try await self.fetchRawResponse(decoder: decoder).data
    }
}

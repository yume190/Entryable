import Foundation
import class Alamofire.DataRequest
import protocol Alamofire.DataPreprocessor
import class Alamofire.DataResponseSerializer
import struct Alamofire.HTTPMethod

struct RequestBuilder {
    let builder: () -> Alamofire.DataRequest
    init (builder: @escaping () -> Alamofire.DataRequest) {
        self.builder = builder
    }
    func build() -> Alamofire.DataRequest {
        builder()
    }
}

public struct Entry<ResponseType> {
    let builder: RequestBuilder
    public let request: Alamofire.DataRequest
    public var queue: DispatchQueue = .main
    public var dataPreprocessor: DataPreprocessor = DataResponseSerializer.defaultDataPreprocessor
    public var emptyResponseCodes: Set<Int> = DataResponseSerializer.defaultEmptyResponseCodes
    public var emptyRequestMethods: Set<HTTPMethod> = DataResponseSerializer.defaultEmptyRequestMethods
    
    init(_ builder: RequestBuilder) {
        self.builder = builder
        self.request = builder.build()
    }
    
    public func reBuild() -> Entry<ResponseType> {
        .init(builder)
    }
    
    public func change(
        queue: DispatchQueue? = nil,
        dataPreprocessor: DataPreprocessor? = nil,
        emptyResponseCodes: Set<Int>? = nil,
        emptyRequestMethods: Set<HTTPMethod>? = nil
    ) -> Entry<ResponseType> {
        var copy = Entry<ResponseType>(self.builder)
        copy.queue = queue ?? self.queue
        copy.dataPreprocessor = dataPreprocessor ?? self.dataPreprocessor
        copy.emptyResponseCodes = emptyResponseCodes ?? self.emptyResponseCodes
        copy.emptyRequestMethods = emptyRequestMethods ?? self.emptyRequestMethods
        return copy
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
        let raw = try await self.fetchRawResponseData()
        return try raw.mapData{ data in
                do {
                    return try ResponseType.decode(data: data, decoder: decoder)
                } catch {
                    throw NetError.url(raw, error)
                }
            }
    }
    
    public func fetch(decoder: JSONDecoder = JSONDecoder()) async throws -> ResponseType {
        return try await self.fetchRawResponse(decoder: decoder).data
    }
}

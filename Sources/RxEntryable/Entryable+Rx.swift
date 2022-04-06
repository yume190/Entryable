import Foundation
import class RxSwift.ConcurrentDispatchQueueScheduler
import class RxSwift.MainScheduler
import struct RxSwift.Disposables
import struct RxSwift.Single
import protocol RxSwift.Disposable

import struct Entryable.Entry
import enum Entryable.NetError
import struct Entryable.HTTPRawResponse

extension Entry {
    public var rxData: Single<HTTPRawResponse<Data>> {
        let request = self.request
        return Single.create { observer -> Disposable in
            request.responseData { (res) in

                let result: Result<HTTPRawResponse<Data>, Error> = res.result.map { data in
                    return HTTPRawResponse(data: data, request: res.request, response: res.response)
                }.mapError { error -> Error in
                    return error
                }
                
                observer(result)
            }

            return Disposables.create {
                request.cancel()
            }
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .observe(on: MainScheduler.instance)
    }
}

extension Entry where ResponseType: Codable {
    public var rx: Single<HTTPRawResponse<ResponseType>> {
        return rxData.map { (response) throws -> HTTPRawResponse<ResponseType> in
            return try response.mapData { data in
                do {
                    return try ResponseType.decode(data: data)
                } catch {
                    throw NetError.url(
                        try? self.request.convertible.asURLRequest().url,
                        data,
                        error
                    )
                }
            }
        }
    }
}

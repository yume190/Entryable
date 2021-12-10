import Foundation
import class RxSwift.ConcurrentDispatchQueueScheduler
import class RxSwift.MainScheduler
import struct RxSwift.Disposables
import struct RxSwift.Single
import protocol RxSwift.Disposable

import protocol Entryable.Entryable
import struct Entryable.HTTPRawResponse

extension Entryable {
    public var rxData: Single<HTTPRawResponse<Data>> {
        return Single.create { observer -> Disposable in
            self.dataRequest.responseData { (res) in

                let result: Result<HTTPRawResponse<Data>, Error> = res.result.map { data in
                    return HTTPRawResponse(data: data, request: res.request, response: res.response)
                }.mapError { error -> Error in
                    return error
                }
                
                observer(result)
            }

            return Disposables.create {
                self.dataRequest.cancel()
            }
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .observe(on: MainScheduler.instance)
    }
}

extension Entryable where ResponseType: Codable {
    public var rx: Single<HTTPRawResponse<ResponseType>> {
        return rxData.map { (response) throws -> HTTPRawResponse<ResponseType> in
            return try response.mapData { data in
                return try ResponseType.decode(data: data)
            }
        }
    }
}

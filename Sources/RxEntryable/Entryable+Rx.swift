import Foundation
import class RxSwift.ConcurrentDispatchQueueScheduler
import class RxSwift.MainScheduler
import struct RxSwift.Disposables
import struct RxSwift.Single
import protocol RxSwift.Disposable

import protocol Entryable.Entryable
import struct Entryable.Response

private let concurrentQueue = DispatchQueue(label: "RxEntryable", attributes: .concurrent)
extension Entryable {
    public var rxData: Single<Response<Data>> {
        return Single.create { observer -> Disposable in
//            self.dataRequest.validate().responseData(queue: concurrentQueue) { (res) in
            self.dataRequest.validate().responseData { (res) in

                let result: Result<Response<Data>, Error> = res.result.map { data in
                    return Response(data: data, request: res.request, response: res.response)
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
    public var rx: Single<Response<ResponseType>> {
        return rxData.map { (response) throws -> Response<ResponseType> in
            return try response.mapData{ data in
                return try ResponseType.decode(data: data)
            }
        }
    }
}

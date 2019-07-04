//import Foundation
import struct RxSwift.Disposables
import class RxSwift.Observable
import protocol RxSwift.Disposable
import Alamofire

extension Entryable {
    public var rxData: Observable<Response<Data>> {
        return Observable.create { observer -> Disposable in
            self.dataRequest
                .validate()
                .responseData { (res) in

                switch res.result {
                case .success:
                    guard let data = res.data else {
                        observer.onError(res.error ?? NetError.unknown)
                        return
                    }

                    let result = Response<Data>(
                        data: data,
                        request: res.request!,
                        response: res.response!
                    )
                    observer.onNext(result)
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                self.dataRequest.cancel()
            }
        }
    }
}

extension Entryable where ResponseType: Codable {
    public var rx: Observable<Response<ResponseType>> {
        return rxData.map { (response) throws -> Response<ResponseType> in
            let data = try ResponseType.decode(data: response.data)
            return Response<ResponseType>(
                data: data,
                request: response.request,
                response: response.response
            )
        }
    }
}

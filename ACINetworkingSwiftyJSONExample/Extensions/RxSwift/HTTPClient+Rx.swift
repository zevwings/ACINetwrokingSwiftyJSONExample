//
//  HTTPClient+Rx.swift
//  ACINetwrokingRxExtensions
//
//  Created by 张伟 on 2021/11/26.
//

import Foundation
import RxSwift
import Dispatch
import ACINetworking

extension HTTPClient: ReactiveCompatible {}

public extension Reactive where Base: Client {

    @discardableResult
    func request(
        _ api: Base.API,
        callbackQueue: DispatchQueue = .main
    ) -> Single<Response> {

        return Single.create(subscribe: { [weak base] single -> Disposable in
            let task = base?.request(
                api: api,
                callbackQueue:
                callbackQueue,
                progressHandler: nil,
                completionHandler: { result in
                    switch result {
                    case let .success(response):
                        single(.success(response))
                    case let .failure(error):
                        single(.failure(error))
                    }
            })
            return Disposables.create {
                task?.cancel()
            }
        })
    }

    @discardableResult
    func requestWithProgress(
        _ api: Base.API,
        callbackQueue: DispatchQueue = .main
    ) -> Observable<ProgressResponse> {

        let progressHandler: (AnyObserver) -> (ProgressResponse) -> Void = { observer in
            return { progress in
                observer.onNext(progress)
            }
        }

        let response: Observable<ProgressResponse> = Observable.create { [weak base] observer in
            
            let task = base?.request(
                api: api,
                callbackQueue: callbackQueue,
                progressHandler: progressHandler(observer),
                completionHandler: { result in
                    switch result {
                    case .success:
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
            })

            return Disposables.create {
                task?.cancel()
            }
        }
  
        return response
    }
}

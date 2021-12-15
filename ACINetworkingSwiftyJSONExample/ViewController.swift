//
//  ViewController.swift
//  ACINetworkingSwiftyJSONExample
//
//  Created by 张伟 on 2021/12/13.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        ///
        ExampleService.shared.request(api: .userInfo) { result in
            do {
                let object = try result.get().mapJSONObject()
                print(object)
            } catch {
                print(error)
            }
        }

        /// RxSwift
        ExampleService.shared.rx.request(.userInfo)
            .filterSuccessfulStatusCodes()
            .mapJSONObject() /// SwiftyJSON Mapping
            .asObservable()
            .subscribe(onNext: { object in
                print(object)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }


}


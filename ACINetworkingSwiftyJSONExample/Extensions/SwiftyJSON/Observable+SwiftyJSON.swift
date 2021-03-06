//
//  Observable+SwiftyJSON.swift
//  SwiftyJSONSupport
//
//  Created by 张伟 on 2019/9/12.
//  Copyright © 2019 zevwings. All rights reserved.
//

import RxSwift
import SwiftyJSON
import ACINetworking

public extension ObservableType where Element == Response {

    func mapJSONObject() -> Observable<JSON> {
        return flatMap { response -> Observable<JSON> in
            return Observable.just(try response.mapJSONObject())
        }
    }
}

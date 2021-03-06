//
//  Single+SwiftyJSON.swift
//  SwiftyJSONSupport
//
//  Created by 张伟 on 2019/9/12.
//  Copyright © 2019 zevwings. All rights reserved.
//

import RxSwift
import SwiftyJSON
import ACINetworking

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func mapJSONObject() -> Single<JSON> {
        return flatMap { response -> Single<JSON> in
            return Single.just(try response.mapJSONObject())
        }
    }
}

//
//  Single+Response.swift
//  ACINetwrokingRxExtensions
//
//  Created by 张伟 on 2021/11/26.
//

import Foundation
import RxSwift
import ACINetworking

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func filter<R: RangeExpression>(statusCodes: R) -> Single<Element> where R.Bound == Int {
        return flatMap { .just(try $0.filter(statusCodes: statusCodes)) }
    }

    func filter(statusCode: Int) -> Single<Element> {
        return flatMap { .just(try $0.filter(statusCode: statusCode)) }
    }

    func filterSuccessfulStatusCodes() -> Single<Element> {
        return flatMap { .just(try $0.filterSuccessfulStatusCodes()) }
    }

    func filterSuccessfulStatusAndRedirectCodes() -> Single<Element> {
        return flatMap { .just(try $0.filterSuccessfulStatusAndRedirectCodes()) }
    }

    ///  将数据转换为图片
    /// - Returns: 图片对象
    func mapImage() -> Single<Image> {
        return flatMap { .just(try $0.mapImage()) }
    }

    /// 将数据转换为 JSON 对象
    /// - Parameters:
    ///   - atKeyPath: 从字典的中取出 `keyPath` 对应的值
    ///   - options: JSONSerialization.ReadingOptions
    ///   - failsOnEmptyData: 错误时是否，返回一个 NSNull 对象
    /// - Returns: JSON 对象
    func mapJSON(failsOnEmptyData: Bool = true) -> Single<Any> {
        return flatMap { .just(try $0.mapJSON(failsOnEmptyData: failsOnEmptyData)) }
    }

    /// 将数据转换为字符串
    /// - Parameter keyPath: KeyPath
    /// - Returns: 字符串
    func mapString(atKeyPath keyPath: String? = nil) -> Single<String> {
        return flatMap { .just(try $0.mapString(atKeyPath: keyPath)) }
    }
    
    /// 将数据转换为 JSON 对象
    /// - Parameters:
    ///   - type: 映射对象类型
    ///   - keyPath: 从字典的中取出 `keyPath` 对应的值，用于映射数据
    ///   - decoder: JSON 解析器
    ///   - failsOnEmptyData: 错误时是否，返回一个 NSNull 对象
    /// - Returns: Decodable 对象
    func map<T>(
        _ type: T.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder = JSONDecoder(),
        failsOnEmptyData: Bool = true
    ) throws -> Single<T> where T: Decodable {
        return flatMap { .just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}

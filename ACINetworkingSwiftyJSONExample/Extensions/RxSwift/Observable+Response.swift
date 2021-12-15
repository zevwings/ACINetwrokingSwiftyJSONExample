//
//  Observable+Response.swift
//  ACINetwrokingRxExtensions
//
//  Created by 张伟 on 2021/11/26.
//

import Foundation
import RxSwift
import ACINetworking

public extension ObservableType where Element == Response {

    func filter<R: RangeExpression>(statusCodes: R) -> Observable<Element> where R.Bound == Int {
        return flatMap { Observable.just(try $0.filter(statusCodes: statusCodes)) }
    }

    func filter(statusCode: Int) -> Observable<Element> {
        return flatMap { Observable.just(try $0.filter(statusCode: statusCode)) }
    }

    func filterSuccessfulStatusCodes() -> Observable<Element> {
        return flatMap { Observable.just(try $0.filterSuccessfulStatusCodes()) }
    }

    func filterSuccessfulStatusAndRedirectCodes() -> Observable<Element> {
        return flatMap { Observable.just(try $0.filterSuccessfulStatusAndRedirectCodes()) }
    }

    ///  将数据转换为图片
    /// - Returns: 图片对象
    func mapImage() -> Observable<Image> {
        return flatMap { Observable.just(try $0.mapImage()) }
    }

    /// 将数据转换为 JSON 对象
    /// - Parameters:
    ///   - atKeyPath: 从字典的中取出 `keyPath` 对应的值
    ///   - options: JSONSerialization.ReadingOptions
    ///   - failsOnEmptyData: 错误时是否，返回一个 NSNull 对象
    /// - Returns: JSON 对象
    func mapJSON(failsOnEmptyData: Bool = true) -> Observable<Any> {
        return flatMap { Observable.just(try $0.mapJSON(failsOnEmptyData: failsOnEmptyData)) }
    }

    /// 将数据转换为字符串
    /// - Parameter keyPath: KeyPath
    /// - Returns: 字符串
    func mapString(atKeyPath keyPath: String? = nil) -> Observable<String> {
        return flatMap { Observable.just(try $0.mapString(atKeyPath: keyPath)) }
    }
    
    /// 将数据转换为 JSON 对象
    /// - Parameters:
    ///   - type: 映射对象类型
    ///   - keyPath: 从字典的中取出 `keyPath` 对应的值，用于映射数据
    ///   - decoder: JSON 解析器
    ///   - failsOnEmptyData: 错误时是否，返回一个 NSNull 对象
    /// - Returns: JSON 对象
    func map<T>(
        _ type: T.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder = JSONDecoder(),
        failsOnEmptyData: Bool = true
    ) throws -> Observable<T> where T: Decodable {
        return flatMap { Observable.just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
    }
}

public extension ObservableType where Element == ProgressResponse {

    func filterCompleted() -> Observable<Response> {
        return self
            .filter { $0.isCompleted }
            .flatMap { progress -> Observable<Response> in
                switch progress.response {
                case .some(let response): return .just(response)
                case .none: return .empty()
                }
        }
    }

    func filterProgress() -> Observable<Double> {
        return self.filter { !$0.isCompleted }.map { $0.progress }
    }
}

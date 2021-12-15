//
//  Response+SwiftyJSON.swift
//  HTTPKit
//
//  Created by 张伟 on 2019/9/12.
//  Copyright © 2019 zevwings. All rights reserved.
//

import Foundation
import SwiftyJSON
import ACINetworking

public extension Response {

    func mapJSONObject() throws -> JSON {
        guard let data = data else {
            let context = HTTPError.Context(request: request, response: response)
            let error = HTTPError.typeMismatch(
                value: try? mapJSON(logSwitch: false),
                targetType: String.self,
                context: context
            )
            HTTPLogger.logFailure(.transform, error: error)
            throw error
        }
        let json: JSON
        do {
            json = try JSON(data: data, options: [.allowFragments, .mutableContainers, .mutableLeaves])
        } catch {
            let context = HTTPError.Context(request: request, response: response)
            let error = HTTPError.typeMismatch(
                value: try? mapJSON(logSwitch: false),
                targetType: String.self,
                context: context
            )
            HTTPLogger.logFailure(.transform, error: error)
            throw error
        }
        
        HTTPLogger.logSuccess(.transform, urlRequest: request, data: json)

        return json
    }
}

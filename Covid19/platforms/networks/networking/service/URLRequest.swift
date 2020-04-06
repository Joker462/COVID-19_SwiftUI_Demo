//
//  URLRequest.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/28/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

extension URLRequest {
    init?(endPoint: EndPoint) {
        let urlComponents = URLComponents(endPoint: endPoint)
        guard let url = urlComponents?.url else { return nil }
        self.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        
        httpMethod = endPoint.method.rawValue
        endPoint.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
        
        guard case let .requestParameters(parameters) = endPoint.task,
            endPoint.parametersEncoding == .json else { return }
        httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}

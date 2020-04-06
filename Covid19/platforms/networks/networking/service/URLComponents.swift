//
//  URLComponents.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/28/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation


extension URLComponents {
    init?(endPoint: EndPoint) {
        let url = endPoint.baseURL.appendingPathComponent(endPoint.path)
        self.init(url: url, resolvingAgainstBaseURL: false)
        
        guard case let .requestParameters(parameters) = endPoint.task,
            endPoint.parametersEncoding == .url else { return }
        
        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}

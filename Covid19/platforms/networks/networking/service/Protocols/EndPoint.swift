//
//  EndPoint.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/28/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

typealias Headers = [String: String]

protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var task: Task { get }
    var headers: Headers? { get }
    var parametersEncoding: ParametersEncoding { get }
}

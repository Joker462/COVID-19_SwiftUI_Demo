//
//  Provider.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/28/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

protocol Provider {
    associatedtype EndPointProvider: EndPoint
    func request(_ endPoint: EndPointProvider, completion: @escaping (NetworkResponse) -> ())
    func cancel()
}

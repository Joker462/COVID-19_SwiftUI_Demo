//
//  Provider.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/28/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import Combine

protocol Provider {
    associatedtype EndPointProvider: EndPoint
    func request(_ endPoint: EndPointProvider, completion: @escaping (NetworkResponse) -> ())
    func request<T: Decodable>(_ endPoint: EndPointProvider, with type: T.Type) -> AnyPublisher<T, Error>
    func request(_ endPoint: EndPointProvider) -> AnyPublisher<Data, Error>
    func cancel()
}

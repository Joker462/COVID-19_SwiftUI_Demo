//
//  NetworkResponse.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/28/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

enum NetworkResponse {
    case success(Data)
    case failure(String)
}

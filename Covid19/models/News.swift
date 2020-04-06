//
//  News.swift
//  newsDemo
//
//  Created by Hung Thai Minh on 2/19/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

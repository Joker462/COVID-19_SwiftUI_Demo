//
//  CovidGlobal.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/29/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

struct CovidGlobal: Codable {
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let updated: Double
    let active: Int
    let affectedCountries: Int
    
    func getDate() -> String {
        let date = Date(timeIntervalSince1970: updated/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm:ss a"
        return dateFormatter.string(from: date)
    }
}

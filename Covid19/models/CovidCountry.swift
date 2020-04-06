//
//  CovidCountry.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/29/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

struct CovidCountry: Codable, Identifiable {
    let id = UUID()
    let country: String
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
    let recovered: Int
    let active: Int
    let critical: Int
    let casesPerOneMillion: Float?
    let deathsPerOneMillion: Float?
    let updated: Double
    let countryInfo: CountryInfo
    
    func getDate() -> String {
        let date = Date(timeIntervalSince1970: updated/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm:ss a"
        return dateFormatter.string(from: date)
    }
}

struct CountryInfo: Codable {
    let _id: Int?
    let iso2: String?
    let iso3: String?
    let lat: Double
    let long: Double
    let flag: String
}

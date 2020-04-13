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
    let cases: Int?
    let todayCases: Int?
    let deaths: Int?
    let todayDeaths: Int?
    let recovered: Int?
    let active: Int?
    let critical: Int?
    let casesPerOneMillion: Float?
    let deathsPerOneMillion: Float?
    let updated: Double?
    let countryInfo: CountryInfo
    
    func getDate(dateFormat: String = "MMMM dd, yyyy HH:mm:ss a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let updated = updated else { return dateFormatter.string(from: Date()) }
        
        let date = Date(timeIntervalSince1970: updated/1000)
        return dateFormatter.string(from: date)
    }
    
    enum CovidCountryType {
        case cases, todayCases, deaths, todayDeaths, recovered, active
    }
    
    subscript(_ type: CovidCountryType) -> Int {
        get {
            switch type {
            case .cases:
                return cases ?? 0
            case .todayCases:
                return todayCases ?? 0
            case .deaths:
                return deaths ?? 0
            case .todayDeaths:
                return todayDeaths ?? 0
            case .recovered:
                return recovered ?? 0
            case .active:
                return active ?? 0
            }
        }
    }
}

struct CountryInfo: Codable {
    let _id: Int?
    let iso2: String?
    let iso3: String?
    let lat: Double?
    let long: Double?
    let flag: String
    
    func getFlagURL() -> URL {
        guard let url = URL(string: flag) else { fatalError("the flag url is empty")}
        return url
    }
}

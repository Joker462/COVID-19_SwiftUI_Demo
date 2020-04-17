//
//  CovidEndPoint.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/29/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation


enum CountriesSortType: String {
    case country = "country"
    case cases   = "cases"
}

enum NetworkEnviroment {
    case qa
    case staging
    case production
}

enum CovidEndPoint {
    case all
    case allCountries (CountriesSortType)
    case historicalDataOfCountry(countryName: String)
    case news
}

let NEWSAPIKEY = ""

extension CovidEndPoint: EndPoint {
    var baseURL: URL {
        switch self {
        case .news:
            guard let url = URL(string: "https://newsapi.org/v2") else { fatalError("baseURL could not be configured.")}
            return url
        default:
            guard let url = URL(string: "https://corona.lmao.ninja/v2") else { fatalError("baseURL could not be configured.")}
            return url
        }
    }
    
    var path: String {
        switch self {
        case .all:
            return "/all"
        case .allCountries:
            return "/countries"
        case let .historicalDataOfCountry(countryName):
            return "/historical/" + countryName
        case .news:
            return "/everything"
        }
    }
    
    var method: Method {
        return .get
    }

    var task: Task {
        switch self {
        case let .allCountries(sortType):
            return .requestParameters(["sort": sortType.rawValue])
        case .historicalDataOfCountry:
            return .requestPlain
        case .news:
            return .requestParameters(["q": "covid",
                                       "from": getTodayDateString(),
                                       "sortBy": "publishedAt",
                                       "pageSize": "100",
                                       "page": "1",
                                       "apiKey": NEWSAPIKEY])
        default :
            return .requestPlain
        }
    }
    
    var headers: Headers? {
        return nil
    }
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        case .historicalDataOfCountry:
            return .json
        default:
            return .url
        }
    }
    
    private func getTodayDateString() -> String {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        date = (cal.date(byAdding: .day, value: -2, to: date)) ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}

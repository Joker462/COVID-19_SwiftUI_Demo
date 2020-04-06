//
//  CovidCountryViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/2/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

final class CovidCountryViewModel: ObservableObject {

    private let provider = URLSessionProvider<CovidEndPoint>()
   
    @Published var isLoading: Bool = true
    private var timeLine: [String: Any] = [:]
    
    func fetchCountryHistoricalData(_ countryName: String) {
        provider.request(.historicalDataOfCountry(countryName: countryName)) { (response) in
            DispatchQueue.main.async { self.isLoading = false }
            switch response {
            case let .success(data):
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                self.timeLine = jsonData?["timeline"] as? [String: Any] ?? [:]
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }
    
    func getTimelineData(from timelineType: TimelineType ) -> [(String, Int)] {
        guard let dictionary = timeLine[timelineType.rawValue] as? [String: Int] else { return [] }
        
        let confirmedCases = Array(dictionary).sorted(by: { self.convertStringToDate($0.0).compare(self.convertStringToDate($1.0)) == .orderedAscending})
        return confirmedCases.suffix(7)
    }
    
    private func convertStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.date(from: dateString) ?? Date()
    }
}

enum TimelineType: String {
    case cases      = "cases"
    case deaths     = "deaths"
    case recovered  = "recovered"
}

//
//  CovidCountriesViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/30/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

final class CovidCountriesViewModel: ObservableObject {
    @Published var covidCountries: [CovidCountry] = []
    @Published var isLoading: Bool = true
    private let provider = URLSessionProvider<CovidEndPoint>()
    
    func fetchCovidCountries() {
        provider.request(.allCountries(.country)) { (response) in
            DispatchQueue.main.async { self.isLoading = false }
            switch response {
            case let .success(data):
                do {
                    let covidCountries = try JSONDecoder().decode([CovidCountry].self, from: data)
                                                          .sorted(by: { $0.cases > $1.cases })
                    DispatchQueue.main.async {
                        self.covidCountries = covidCountries.first?.country == "World"
                                              ? Array(covidCountries.suffix(from: 1))
                                              : covidCountries
                    }
                } catch {
                    print(error.localizedDescription)
                }
                break
            case let .failure(error):
                print(error)
                break
            }
        }
    }
}

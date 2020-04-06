//
//  CovidGlobalViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/30/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation

final class CovidGlobalViewModel: ObservableObject {
    
    private let provider = URLSessionProvider<CovidEndPoint>()
    @Published var covidGlobal: CovidGlobal?
    @Published var isLoading: Bool = true
    @Published var isApiCalled: Bool = false
    
    func fetchCovidGlobal() {
        provider.request(.all) { (response) in
            DispatchQueue.main.async { self.isApiCalled = true }
            switch response {
            case let .success(data):
                do {
                    let covidGlobal = try JSONDecoder().decode(CovidGlobal.self, from: data)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.covidGlobal = covidGlobal
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

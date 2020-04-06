//
//  CovidNewsViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/4/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation


final class CovidNewsViewModel: ObservableObject {
    private let provider = URLSessionProvider<CovidEndPoint>()
    @Published var news: News? = nil
    @Published var isLoading: Bool = true
    @Published var isApiCalled: Bool = false
    
    func fetchNews() {
        provider.request(.news) { (response) in
            DispatchQueue.main.async { self.isApiCalled = true }
            switch response {
            case let .success(data):
                let news = try? JSONDecoder().decode(News.self, from: data)
                DispatchQueue.main.async {
                    self.news = news
                    self.isLoading = news == nil
                }
                break
            case let.failure(error):
                print(error)
                DispatchQueue.main.async {self.isLoading = true}
                break
            }
        }
    }
}

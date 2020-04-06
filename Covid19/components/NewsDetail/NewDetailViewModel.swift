//
//  NewDetailViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/4/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation


final class NewsDetailViewModel: ObservableObject {
    @Published var urlLink: String
    @Published var isLoading: Bool = true
    
    init(_ article: Article) {
        urlLink = article.url ?? ""
    }
}

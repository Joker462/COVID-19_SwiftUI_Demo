//
//  NewsDetailView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/4/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import SwiftUI

struct NewsDetailView: View {
    
    @ObservedObject var viewModel: NewsDetailViewModel
    
    init(_ article: Article) {
        viewModel = NewsDetailViewModel(article)
    }
    
    var body: some View {
        LoadingWebView(isShowing: $viewModel.isLoading) {
            WebView(urlLink: self.$viewModel.urlLink, isLoading: self.$viewModel.isLoading)
        }
        .navigationBarTitle("News", displayMode: .inline)
    }
}

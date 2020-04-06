//
//  CovidNewsView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/4/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import SwiftUI

struct CovidNewsView: View {
    
    @ObservedObject var viewModel = CovidNewsViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                List(viewModel.news!.articles) { article in
                    ZStack {
                        CovidNewsCardView(article)
                        NavigationLink(destination: NewsDetailView(article)) {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Coronavirus news")
        .onAppear {
            if !self.viewModel.isApiCalled {
                self.viewModel.fetchNews()
            }
        }
    }
    
    
}

struct CovidNewsCardView: View {
    
    private let article: Article
    
    init(_ article: Article) {
        self.article = article
    }
    
    var body: some View {
        VStack {
            if (article.urlToImage == nil) {
                VStack(alignment: .leading) {
                    Text(article.title)
                        .font(.headline)
                    Spacer()
                    Text(article.author ?? article.source.name)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }.frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack {
                    ImageView(withURL: article.urlToImage ?? "")
                        .background(Color.gray)
                        .frame(width: 120, height: 80, alignment: .center)
                        .clipped()
                    Spacer()
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.headline)
                        Spacer()
                        Text(article.author ?? article.source.name)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack { Divider() }
        }
    }
}

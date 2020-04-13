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
    @State var article: Article? = nil
    
    var body: some View {
        content
        .navigationBarTitle("Covid-19 News")
        .onAppear {
            self.viewModel.send(event: .onAppear)
        }
    }
    
    var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return LoadingView().eraseToAnyView()
        case .loaded(let news):
            return newsListView(news.articles).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        }
    }
    
    
    private func newsListView(_ articles: [Article]) -> some View {
        return List(articles) { article in
            ZStack {                
                CovidNewsCardView(article)
                    .onTapGesture {
                        self.article = article
                }
                EmptyView()
            }
            .sheet(item: self.$article, content: { article in
                SafariView(url: article.getURL())
            })
        }
    }
    
}

struct CovidNewsCardView: View {
    @Environment(\.imageCache) var cache: ImageCache
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
                    ImageView(url: article.getURLImage(),
                              cache: cache,
                              placeholder: Image("placeholder"),
                              configuration: { $0.resizable() })
                        .frame(width: 120, height: 80, alignment: .center)
                        .clipped()
                        .aspectRatio(contentMode: .fill)
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

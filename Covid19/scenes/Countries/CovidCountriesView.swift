//
//  CovidCountriesView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/30/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import SwiftUI

struct CovidCountriesView: View {
    @ObservedObject var viewModel = CovidCountriesViewModel()
    @ObservedObject var searchViewInput = SearchViewInput()
    
    var body: some View {
        content
        .navigationBarTitle("Countries Covid-19")
        .resignKeyboardOnDragGesture()
        .onAppear {
            self.viewModel.send(event: .onAppear)
        }
    }
}

private extension CovidCountriesView {
    var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return LoadingView().eraseToAnyView()
        case .loaded(let covidCountries):
            return countriesView(covidCountries).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        }
    }
    
    private func countriesView(_ countries: [CovidCountry]) -> some View {
        return VStack {
            SearchView(placeHolder: "Search country name", searchText: $searchViewInput.text)
            List(countries.filter {
                $0.country.lowercased().hasPrefix(self.searchViewInput.text.lowercased()) || self.searchViewInput.text == ""})
            { covidCountry in
                ZStack {
                    CovidCountriesCardView(covidCountry: covidCountry)
                    NavigationLink(destination: CovidCountryView(covidCountry)) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct CovidCountriesCardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.imageCache) var cache: ImageCache
    
    private let covidCountry: CovidCountry
    
    init(covidCountry: CovidCountry) {
        self.covidCountry = covidCountry
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorScheme == .dark ? Color.black : Color.white)
                .shadow(color: Color.secondary.opacity(0.7), radius: 3)
            HStack {
                VStack {
                    Text(covidCountry.country)
                        .font(.headline)
                        .bold()
                    ImageView(url: covidCountry.countryInfo.getFlagURL(),
                              cache: cache,
                              placeholder: Image("placeholder"),
                              configuration: { $0.resizable() })
                        .frame(width: 60, height: 40)
                        .aspectRatio(contentMode: .fill)
                }.frame(width: 120, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("CASES: \(covidCountry[.cases]) [+\(covidCountry[.todayCases])]")
                        .foregroundColor(.secondary)
                    Text("DEATHS: \(covidCountry[.deaths]) [+\(covidCountry[.todayDeaths])]")
                        .foregroundColor(.red)
                    Text("RECOVERED: \(covidCountry[.recovered])")
                        .foregroundColor(.green)
                    Text("ACTIVE: \(covidCountry[.active])")
                        .foregroundColor(.accentColor)
                }.padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
        }
        
    }
}

struct CovidCountriesView_Previews: PreviewProvider {
    static var previews: some View {
        CovidCountriesView()
    }
}

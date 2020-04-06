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
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                VStack {
                    SearchView(placeHolder: "Search country name", searchText: $searchViewInput.text)
                    List(viewModel.covidCountries.filter { $0.country.hasPrefix(self.searchViewInput.text) || self.searchViewInput.text == ""}) { covidCountry in
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
        .navigationBarTitle("Countries Covid-19")
        .resignKeyboardOnDragGesture()
        .onAppear {
            if self.viewModel.isLoading {
                self.viewModel.fetchCovidCountries()
            }
        }
    }
}

struct CovidCountriesCardView: View {
    private let covidCountry: CovidCountry
    
    init(covidCountry: CovidCountry) {
        self.covidCountry = covidCountry
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.7), radius: 3)
            HStack {
                VStack {
                    Text(covidCountry.country)
                        .font(.headline)
                        .bold()
                    ImageView(withURL: covidCountry.countryInfo.flag)
                        .frame(width: 60, height: 40)
                }.frame(width: 120, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("CASES: \(covidCountry.cases) [+\(covidCountry.todayCases)]")
                        .foregroundColor(.secondary)
                    Text("DEATHS: \(covidCountry.deaths) [+\(covidCountry.todayDeaths)]")
                        .foregroundColor(.red)
                    Text("RECOVERED: \(covidCountry.recovered)")
                        .foregroundColor(.green)
                    Text("ACTIVE: \(covidCountry.active)")
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

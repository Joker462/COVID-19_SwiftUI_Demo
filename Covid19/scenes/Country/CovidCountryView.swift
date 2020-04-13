//
//  CovidCountryView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/1/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct CovidCountryView: View {
    private let countryName: String
    @ObservedObject var viewModel: CovidCountryViewModel

    init(_ covidCountry: CovidCountry) {
        countryName = covidCountry.country
        viewModel = CovidCountryViewModel(covidCountry)
    }
    
    var body: some View {
        contentView
        .navigationBarTitle(countryName)
        .onAppear {
            self.viewModel.send(event: .onAppear)
        }
    }
    
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return LoadingView().eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let caseConfirmedList):
            return renderCardView(caseConfirmedList).eraseToAnyView()
        }
    }
    
    private func renderCardView(_ caseConfirmedList: [CaseConfirmed]) -> some View {
         List(caseConfirmedList) {
            CovidCountryCardView(cases: $0.value,
                                 recovered: self.viewModel.findValue(from: $0.daily, timelineType: .recovered),
                                 deaths: self.viewModel.findValue(from: $0.daily, timelineType: .deaths),
                                 dayString: $0.daily)
        }
    }
    
}


struct CovidCountryCardView: View {
    private let cases: Int
    private let recovered: Int
    private let deaths: Int
    private let dayString: String
    
    init(cases: Int,
         recovered: Int,
         deaths: Int,
         dayString: String) {
        self.cases = cases
        self.recovered = recovered
        self.deaths = deaths
        self.dayString = dayString
    }
    
    var body: some View {
        VStack {
            Text(dayString)
                .font(.headline)
                .bold()
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Text("Cases")
                    Text("\(cases.getCurrencyFormatting())")
                }.foregroundColor(.secondary)
                Spacer()
                VStack(alignment: .center) {
                    Text("Recovered")
                    Text("\(recovered.getCurrencyFormatting())")
                }.foregroundColor(.green)
                Spacer()
                VStack(alignment: .center) {
                    Text("Deaths")
                    Text("\(deaths.getCurrencyFormatting())")
                }.foregroundColor(.red)
                Spacer()
            }.padding(.vertical)
        VStack { Divider() }
        }
    }
}

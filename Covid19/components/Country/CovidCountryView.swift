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

    private let covidCountry: CovidCountry
    @ObservedObject var viewModel = CovidCountryViewModel()

    init(_ covidCountry: CovidCountry) {
        self.covidCountry = covidCountry
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else {
                AnyView(contentView)
            }
        }
        .navigationBarTitle(covidCountry.country)
        .onAppear {
            self.viewModel.fetchCountryHistoricalData(self.covidCountry.country)
        }
    }
    
    var contentView: some View {
        List {
            VStack(alignment: .leading) {
                Text("Last Updated at:")
                    .font(.body)
                    .foregroundColor(.secondary)
                Text(covidCountry.getDate())
                    .font(.headline)
                Spacer()
                Spacer()
                Text("Displaying last 7 days of coronavirus information at \(covidCountry.country)")
                    .font(.headline)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                BarChartView(data: ChartData(values: viewModel.getTimelineData(from: .cases)),
                            title: "Total Confirmed",
                            legend: covidCountry.cases.getCurrencyFormatting(),
                            style: Styles.barChartStyleNeonBlueLight,
                            cornerImage: Image(systemName: "waveform.path.ecg"),
                            valueSpecifier: "%.0f")
                Spacer()
                BarChartView(data: ChartData(values: viewModel.getTimelineData(from: .recovered)),
                             title: "Total Recovered",
                             legend: covidCountry.recovered.getCurrencyFormatting(),
                             style: Styles.barChartMidnightGreenLight,
                             cornerImage: Image(systemName: "heart.fill"),
                             valueSpecifier: "%.0f")
            }
            
            BarChartView(data: ChartData(values: viewModel.getTimelineData(from: .deaths)),
                                        title: "Total Deaths",
                                        legend: covidCountry.deaths.getCurrencyFormatting(),
                                        style: Styles.barChartStyleOrangeLight,
                                        cornerImage: Image(systemName: "staroflife.fill"),
                                        valueSpecifier: "%.0f")
        }
    }
}

//
//  CovidGlobalView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/30/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import SwiftUI

struct CovidGlobalView: View {
    
    @ObservedObject var viewModel = CovidGlobalViewModel()
    
    init() {
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        AnyView(content())
        .onAppear {
            if !self.viewModel.isApiCalled {
                self.viewModel.fetchCovidGlobal()
            }
        }
    }
}

private extension CovidGlobalView {
    func content() -> some View {
        if let covidGlobal = viewModel.covidGlobal {
            return AnyView(renderContentView(covidGlobal))
        } else {
            return AnyView(loading)
        }
    }
    
    var loading: some View {
        Text("Loading Covid Global content ....")
    }
    
    func renderContentView(_ covidGlobal: CovidGlobal) -> some View {
        CovidGlobalContentView(covidGlobal)
    }
}

struct CovidGlobalContentView: View {
    private let covidGlobal: CovidGlobal
    
    init(_ covidGlobal: CovidGlobal) {
        self.covidGlobal = covidGlobal
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Coronavirus Covid-19 Global Cases")
                .font(.headline)
            Text("Last Updated at:")
                .font(.body)
                .foregroundColor(.secondary)
            Text(covidGlobal.getDate())
                .font(.headline)

            Spacer()
            
            Group {
                Text("Coronavirus Cases:")
                Text(covidGlobal.cases.getCurrencyFormatting() + "  [+\(covidGlobal.todayCases)]")
                    .foregroundColor(.secondary)
                
                Text("Deaths:")
                Text(covidGlobal.deaths.getCurrencyFormatting() + "  [+\(covidGlobal.todayDeaths)]")
                    .foregroundColor(.red)
                
                Text("Recovered:")
                Text(covidGlobal.recovered.getCurrencyFormatting())
                    .foregroundColor(.green)
                
                Text("Affected countries:")
                Text(covidGlobal.affectedCountries.getCurrencyFormatting())
                    .foregroundColor(.accentColor)
            }.font(.title)
            
            Spacer()
        }
    }
}


struct CovidGlobalView_Previews: PreviewProvider {
    static var previews: some View {
        CovidGlobalView()
    }
}

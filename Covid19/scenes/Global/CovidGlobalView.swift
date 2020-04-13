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
    
    var body: some View {
        content
        .onAppear {
            self.viewModel.send(event: .onAppear)
        }
    }
}

private extension CovidGlobalView {

    var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Text("Loading Covid Global content ....").eraseToAnyView()
        case .loaded(let covidGlobal):
            return CovidGlobalContentView(covidGlobal).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        }
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

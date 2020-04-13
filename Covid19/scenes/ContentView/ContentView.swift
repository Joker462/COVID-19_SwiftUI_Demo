//
//  ContentView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/28/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tabViewSelected: TabViewType = .global
    
    enum TabViewType: Hashable {
        case global, countries, news, about
    }
    
    init() {
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        TabView(selection: $tabViewSelected) {
            CovidGlobalView()
            .tabItem {
                Image(systemName: "globe")
                Text("Global")
            }.tag(TabViewType.global)
            
            NavigationView {
                CovidCountriesView()
            }.accentColor(.primary)
            .tabItem {
                Image(systemName: "flag.fill")
                Text("Countries")
            }.tag(TabViewType.countries)
            
            NavigationView {
                CovidNewsView()
            }.accentColor(.primary)
            .tabItem {
                Image(systemName: "paperplane.fill")
                Text("News")
            }.tag(TabViewType.news)
            
            NavigationView {
                AboutView()
            }
            .tabItem {
                Image(systemName: "questionmark.circle.fill")
                Text("About")
            }.tag(TabViewType.about)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

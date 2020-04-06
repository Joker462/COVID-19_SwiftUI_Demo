//
//  ContentView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/28/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            CovidGlobalView()
            .tabItem {
                Image(systemName: "globe")
                Text("Global")
            }
            
            NavigationView {
                CovidCountriesView()
            }
            .tabItem {
                Image(systemName: "flag.fill")
                Text("Countries")
            }
            
            NavigationView {
                CovidNewsView()
            }
            .tabItem {
                Image(systemName: "paperplane.fill")
                Text("News")
            }
            
            NavigationView {
                AboutView()
            }
            .tabItem {
                Image(systemName: "questionmark.circle.fill")
                Text("About")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

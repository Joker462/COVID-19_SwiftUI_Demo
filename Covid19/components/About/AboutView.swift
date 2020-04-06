//
//  AboutView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/30/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("This application displaying the coronavirus information (COVID-19).")
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Text("About me:")
                Button("Hung Thai") {
                    UIApplication.shared.open(URL(string: "https://github.com/Joker462")!)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }.padding()
            
        .navigationBarTitle("About")
    }
}


struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

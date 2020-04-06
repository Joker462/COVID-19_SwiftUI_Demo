//
//  ImageView.swift
//  MovieApp
//
//  Created by Hung Thai Minh on 12/16/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var placeholder: Image = Image("placeholder")
    
    init(withURL url: String) {
        imageLoader = ImageLoader(urlString: url)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
            .fill(Color.white)
            .shadow(color: Color.gray, radius: 2)
            VStack {
                placeholder
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .foregroundColor(.gray)
            }.onReceive(imageLoader.didChange) { data in
                guard let data = data,
                    let uiImage = UIImage(data: data) else {
                        return
                }
                
                self.placeholder = Image(uiImage: uiImage)
            }
        }
    }
}

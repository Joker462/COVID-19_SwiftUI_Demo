//
//  ImageView.swift
//  MovieApp
//
//  Created by Hung Thai Minh on 12/16/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageView<Placeholder: View>: View {
    @ObservedObject private var imageLoader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image
    
    init(url: URL,
         cache: ImageCache? = nil,
         placeholder: Placeholder? = nil,
         configuration: @escaping (Image) -> Image = { $0 }) {
        imageLoader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    var body: some View {
        image
            .onAppear(perform: imageLoader.load)
            .onDisappear(perform: imageLoader.cancel)
    }
    
    private var image: some View {
        Group {
            if imageLoader.image == nil {
                placeholder
            } else {
                configuration(Image(uiImage: imageLoader.image!))
            }
        }
    }
}

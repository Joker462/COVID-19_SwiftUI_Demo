//
//  LoadingView.swift
//  MovieApp
//
//  Created by Hung Thai Minh on 12/16/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import SwiftUI

struct LoadingView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LoadingView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .medium)
    }
    
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingView>) {
        uiView.startAnimating()
    }
}

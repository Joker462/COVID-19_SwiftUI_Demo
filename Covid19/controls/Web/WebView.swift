//
//  WebView.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/4/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
      
    @Binding var urlLink: String
    @Binding var isLoading: Bool
      
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var urlLink: String
        @Binding var isLoading: Bool
        
        init(urlLink: Binding<String>, isLoading: Binding<Bool>) {
            _urlLink = urlLink
            _isLoading = isLoading
        }
        

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }
    }
    
    func makeCoordinator() -> WebView.Coordinator {
        return Coordinator(urlLink: $urlLink, isLoading: $isLoading)
    }
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: urlLink) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
      
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        return
    }
      
}  


struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingWebView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geomatry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
            
                ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                    .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}


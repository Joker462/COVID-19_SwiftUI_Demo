//
//  ImageLoader.swift
//  MovieApp
//
//  Created by Hung Thai Minh on 12/16/19.
//  Copyright © 2019 Hung Thai Minh. All rights reserved.
//

import Combine
import Foundation

final class ImageLoader: ObservableObject {
    let didChange = PassthroughSubject<Data?, Never>()
    var task: URLSessionTask?
    var data: Data? = nil {
        didSet {
            didChange.send(data)
        }
    }
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    init(urlString: String) {
        if let data = imageCache.object(forKey: urlString as AnyObject) as? Data {
            self.data = data
            return
        }
        
        guard let url = URL(string: urlString) else {
            data = nil
            return
        }
        task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { self.data = nil }
                return
            }
            DispatchQueue.main.async {
                self.data = data
                self.imageCache.setObject(data as AnyObject, forKey: urlString as AnyObject)
            }
        }
        task?.resume()
    }
    
    deinit {
        task?.cancel()
    }
}

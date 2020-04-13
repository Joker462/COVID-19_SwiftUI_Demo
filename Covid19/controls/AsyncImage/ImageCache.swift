//
//  ImageCache.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/13/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import SwiftUI

protocol ImageCache {
    subscript(_ key: URL) -> UIImage? { get set }
}


struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
    
    struct TemporaryImageCache: ImageCache {
        private let cache = NSCache<NSURL, UIImage>()
        
        subscript(_ key: URL) -> UIImage? {
            get { cache.object(forKey: key as NSURL) }
            set {
                newValue == nil
                    ? cache.removeObject(forKey: key as NSURL)
                    : cache.setObject(newValue!, forKey: key as NSURL)
            }
        }
    }
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

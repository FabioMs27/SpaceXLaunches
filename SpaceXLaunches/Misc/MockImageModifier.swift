//
//  MockImageModifier.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 09.10.2024.
//

import Foundation
import Kingfisher
import SwiftUI

struct MockImageModifier: ViewModifier {
    
    private let imageCache: ImageCache
    private let manager: KingfisherManager
    
    init(imageCache: ImageCache, manager: KingfisherManager = .shared) {
        self.imageCache = imageCache
        self.manager = manager
    }
    
    init(
        name: String,
        image: UIImage,
        cacheKey: String
    ) {
        self.imageCache = ImageCache(name: name)
        self.manager = .shared
        imageCache.store(
            image,
            forKey: cacheKey,
            toDisk: false
        )
        
        manager.defaultOptions = [
            .onlyFromCache,
            .targetCache(imageCache)
        ]
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func mockCachedImages(
        name: String = "test-images",
        image: UIImage,
        cacheKey: String
    ) -> some View {
        self.modifier(
            MockImageModifier(
                name: name,
                image: image,
                cacheKey: cacheKey
            )
        )
    }
}

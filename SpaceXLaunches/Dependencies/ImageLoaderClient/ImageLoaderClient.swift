//
//  ImageLoaderClient.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 07.10.2024.
//

import Dependencies
import Foundation
import UIKit

struct ImageLoaderClient {
    enum Failure: Error {
        case invalidUrl
        case decodingError
    }
    
    var loadImageFromUrl: (URL?) async throws -> UIImage
}

// MARK: Live
extension ImageLoaderClient {
    static func live(session: URLSession = .shared) -> Self {
        .init(
            loadImageFromUrl: { imageUrl in
                guard let imageUrl else { throw Failure.invalidUrl }
                let (data, _) = try await session.data(from: imageUrl)
                guard let image = UIImage(data: data) else { throw Failure.decodingError }
                return image
            }
        )
    }
}

// MARK: Mock
extension ImageLoaderClient {
    static let mock = Self.init(loadImageFromUrl: { _ in UIImage(systemName: "profile") ?? .init() })
}

// MARK: - Dependencies
extension ImageLoaderClient: DependencyKey {
    public static let liveValue = ImageLoaderClient.live()
    public static let previewValue = ImageLoaderClient.mock
}

extension DependencyValues {
    var imageLoaderClient: ImageLoaderClient {
        get { self[ImageLoaderClient.self] }
        set { self[ImageLoaderClient.self] = newValue }
    }
}

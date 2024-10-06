//
//  Launch.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import Foundation

struct PaginatedResponse<Model: Codable>: Codable {
    let docs: [Model]
    let totalPages: Int
    let page: Int
    let hasNextPage: Bool
}

struct Launch: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String?
    let imageUrl: URL?
    let date: Date
}

// MARK: - Mocks
extension Launch {
    static func mock(id: UUID = .init()) -> Self {
        .init(
            id: id,
            name: "FalconSat",
            description: "Engine failure at 33 seconds and loss of vehicle",
            imageUrl: .none,
            date: .distantPast
        )
    }
}

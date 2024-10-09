//
//  APIClient.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import Dependencies
import Foundation

struct APIClient {
    var fetchPastLaunches: (LaunchesRequest) async throws -> PaginatedResponse<Launch>
}

// MARK: - Live
extension APIClient {
    static func live(agent: NetworkAgent) -> Self {
        .init(
            fetchPastLaunches: { request in
                let response: PaginatedResponse<LaunchDto> = try await agent.run(SpaceXAPI.pastLaunches(request))
                return .init(
                    docs: response.docs.map(Launch.init(launchDto:)),
                    totalPages: response.totalPages,
                    page: response.page,
                    hasNextPage: response.hasNextPage
                )
            }
        )
    }
}

// MARK: - Mock
extension APIClient {
    static var mock: Self {
        .init(fetchPastLaunches: { request in
                .init(
                    docs: (1...request.options.limit).map { _ in .mock(id: UUID().uuidString) },
                    totalPages: 5,
                    page: request.options.page,
                    hasNextPage: (request.options.page + 1) < 5
                )
        })
    }
}

// MARK: - Dependencies
extension APIClient: DependencyKey {
    public static let liveValue = APIClient.live(agent: .init())
    public static let previewValue = APIClient.mock
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

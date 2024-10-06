//
//  APIClient.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import Dependencies
import Foundation

struct APIClient {
    var fetchPastLaunches: (_ page: Int, _ pageSize: Int) async throws -> PaginatedResponse<Launch>
}

// MARK: - Live
extension APIClient {
    static func live(agent: NetworkAgent) -> Self {
        .init(
            fetchPastLaunches: { page, pageSize in
                let response: PaginatedResponse<LaunchDto> = try await agent.run(SpaceXAPI.pastLaunches)
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
        .init(fetchPastLaunches: { page, _ in
                .init(
                    docs: (0...10).map { .mock(id: .init($0)) },
                    totalPages: 10,
                    page: page,
                    hasNextPage: page < 10
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

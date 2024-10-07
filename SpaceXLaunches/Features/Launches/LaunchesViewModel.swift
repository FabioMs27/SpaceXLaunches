//
//  LaunchesViewModel.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import Dependencies
import Foundation
import UIKitNavigation

@Perceptible
class LaunchesViewModel {
    
    enum RequestState {
        case inFlight
        case error(description: String)
    }
    
    @CasePathable
    enum Destination {
        case launchDetails
    }
    
    @PerceptionIgnored
    @Dependency(\.apiClient) var apiClient
    
    var requestState: RequestState?
    var searchQuery: String
    var launches: [Launch]
    let pageSize: Int
    
    var filteredLaunches: [Launch] {
        guard !searchQuery.isEmpty else { return launches }
        return launches.filter {
            $0.name.contains(searchQuery)
        }
    }
    
    var launchesListItems: [Launches.Output.Item] {
        filteredLaunches.map(Launches.Output.Item.init)
    }
    
    init(
        requestState: RequestState? = .none,
        searchQuery: String = .init(),
        launches: [Launch] = [],
        pageSize: Int = 10
    ) {
        self.requestState = requestState
        self.searchQuery = searchQuery
        self.launches = launches
        self.pageSize = pageSize
    }
    
}

@MainActor
extension LaunchesViewModel {
    func fetchPastLaunchesAllPages() async {
        var hasNextPage: Bool
        var page = 0
        do {
            // Fetch first page and handle state + error
            requestState = .inFlight
            let firstResponse = try await apiClient.fetchPastLaunches(.init(page: page, pageSize: pageSize))
            launches = firstResponse.docs
            page = firstResponse.page + 1
            hasNextPage = firstResponse.hasNextPage
            requestState = .none
            
            // Fetch other pages silently
            while hasNextPage,
                  let response = try? await apiClient.fetchPastLaunches(.init(page: page, pageSize: pageSize)) {
                launches.append(contentsOf: response.docs)
                page = response.page + 1
                hasNextPage = response.hasNextPage
            }
            
        } catch {
            requestState = .error(description: "An Error occurred!")
        }
    }
}

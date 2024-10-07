//
//  LaunchesViewModel.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import Dependencies
import Foundation
import UIKitNavigation

class LaunchesViewModel: ObservableObject {
    
    enum RequestState {
        case inFlight
        case error(description: String)
    }
    
    @CasePathable
    enum Destination {
        case launchDetails
    }
    
    @Dependency(\.apiClient) var apiClient
    
    @Published var requestState: RequestState?
    @Published var searchQuery: String
    @Published var launches: [Launch]
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
        requestState: RequestState?,
        searchQuery: String = .init(),
        launches: [Launch],
        pageSize: Int
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
            let firstResponse = try await apiClient.fetchPastLaunches(page, pageSize)
            launches = firstResponse.docs
            page = firstResponse.page + 1
            hasNextPage = firstResponse.hasNextPage
            requestState = .none
            
            // Fetch other pages silently
            while hasNextPage,
                  let response = try? await apiClient.fetchPastLaunches(page, pageSize) {
                launches.append(contentsOf: response.docs)
                page = response.page + 1
                hasNextPage = response.hasNextPage
            }
            
        } catch {
            requestState = .error(description: "An Error occurred!")
        }
    }
}

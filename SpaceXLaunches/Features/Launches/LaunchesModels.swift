//
//  LaunchesModels.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 07.10.2024.
//

import Foundation

enum Launches {
    enum Output {}
}

extension Launches.Output {
    enum Section: Hashable {
        case main
    }
    
    struct Item: Identifiable, Hashable {
        let id: String
        let name: String
        let description: String?
        let launchDate: String?
        let imageUrl: URL?
    }
}

// MARK: - Mapping
extension Launches.Output.Item {
    init(launch: Launch) {
        let launchDate: String? = if let date = launch.date {
            launchEventOutput.string(from: date)
        } else {
            nil
        }
        self = .init(
            id: launch.id,
            name: launch.name,
            description: launch.description,
            launchDate: launchDate,
            imageUrl: launch.imageUrl
        )
    }
}

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
    struct Item: Identifiable {
        let id: UUID
        let name: String
        let description: String?
        let launchDate: String
        let imageUrl: URL?
    }
}

// MARK: - Mapping
extension Launches.Output.Item {
    init(launch: Launch) {
        self = .init(
            id: launch.id,
            name: launch.name,
            description: launch.description,
            launchDate: launchEventOutput.string(from: launch.date),
            imageUrl: launch.imageUrl
        )
    }
}

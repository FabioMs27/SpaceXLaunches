//
//  LaunchDto.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import Foundation

// MARK: - Launch
struct LaunchDto: Codable {
    let fairings: FairingsDto?
    let links: LinksDto
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool
    let window: Int
    let rocket: String
    let success: Bool?
    let failures: [FailureDto]
    let details: String?
    let crew, ships, capsules, payloads: [String]
    let launchpad: String
    let flightNumber: Int
    let name: String
    let dateUTC: Date
    let dateUnix: Int
    let dateLocal: String
    let datePrecision: String
    let upcoming: Bool
    let cores: [CoreDto]
    let autoUpdate, tbd: Bool
    let launchLibraryID: String?
    let id: UUID

    enum CodingKeys: String, CodingKey {
        case fairings, links
        case staticFireDateUTC = "static_fire_date_utc"
        case staticFireDateUnix = "static_fire_date_unix"
        case net, window, rocket, success, failures, details, crew, ships, capsules, payloads, launchpad
        case flightNumber = "flight_number"
        case name
        case dateUTC = "date_utc"
        case dateUnix = "date_unix"
        case dateLocal = "date_local"
        case datePrecision = "date_precision"
        case upcoming, cores
        case autoUpdate = "auto_update"
        case tbd
        case launchLibraryID = "launch_library_id"
        case id
    }
}

// MARK: - Core
struct CoreDto: Codable {
    let core: String
    let flight: Int
    let gridfins, legs, reused, landingAttempt: Bool
    let landingSuccess: Bool?
    let landingType, landpad: String?

    enum CodingKeys: String, CodingKey {
        case core, flight, gridfins, legs, reused
        case landingAttempt = "landing_attempt"
        case landingSuccess = "landing_success"
        case landingType = "landing_type"
        case landpad
    }
}

// MARK: - Fairings
struct FairingsDto: Codable {
    let reused, recoveryAttempt, recovered: Bool
    let ships: [String]

    enum CodingKeys: String, CodingKey {
        case reused
        case recoveryAttempt = "recovery_attempt"
        case recovered, ships
    }
}

// MARK: - Failure
struct FailureDto: Codable {
    let time: Int
    let altitude: Int?
    let reason: String
}

// MARK: - Links
struct LinksDto: Codable {
    let patch: PatchDto
    let reddit: RedditDto
    let flickr: FlickrDto
    let presskit: String?
    let webcast: String
    let youtubeID: String
    let article: String
    let wikipedia: String

    enum CodingKeys: String, CodingKey {
        case patch, reddit, flickr, presskit, webcast
        case youtubeID = "youtube_id"
        case article, wikipedia
    }
}

// MARK: - Flickr
struct FlickrDto: Codable {
    let small, original: [String]
}

// MARK: - Patch
struct PatchDto: Codable {
    let small, large: URL?
}

// MARK: - Reddit
struct RedditDto: Codable {
    let campaign, launch, media, recovery: String?
}

// MARK: - Mapping
extension Launch {
    init(launchDto: LaunchDto) {
        self = .init(
            id: launchDto.id,
            name: launchDto.name,
            description: launchDto.details,
            imageUrl: launchDto.links.patch.small,
            date: launchDto.dateUTC
        )
    }
}

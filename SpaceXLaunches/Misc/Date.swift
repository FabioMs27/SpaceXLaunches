//
//  Date.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 07.10.2024.
//

import Foundation

var launchEventOutput: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.iso8601UTC.timeZone
    formatter.locale = Calendar.iso8601UTC.locale
    formatter.dateFormat = "MM/d/yyyy"
    return formatter
}()

extension Calendar {
    static let iso8601UTC: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
}

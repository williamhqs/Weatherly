//
//  AppLogger.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import OSLog

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "Weatherly"

    static let network = Logger(subsystem: subsystem, category: "network")
    static let weather = Logger(subsystem: subsystem, category: "weather")
}

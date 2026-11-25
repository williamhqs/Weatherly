//
//  ForecastDayFormatter.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import Foundation

struct ForecastDayFormatter {
    private let timeZone: TimeZone
    private let locale: Locale

    init(
        timeZoneIdentifier: String,
        locale: Locale = .current
    ) {
        self.timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .current
        self.locale = locale
    }

    func string(from date: Date) -> String {
        var style = Date.FormatStyle(locale: locale)
            .weekday(.abbreviated)
            .month(.abbreviated)
            .day()

        style.timeZone = timeZone

        return date.formatted(style)
    }
}

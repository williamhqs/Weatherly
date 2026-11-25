//
//  ForecastDayFormatterTests.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import Foundation
import Testing
@testable import Weatherly

@MainActor
struct ForecastDayFormatterTests {

    @Test func formatsDateInGivenTimeZone() throws {
        let formatter = ForecastDayFormatter(
            timeZoneIdentifier: "Asia/Singapore",
            locale: Locale(identifier: "en_US")
        )
        let date = try makeDate(
            timeZoneIdentifier: "Asia/Singapore",
            year: 2026, month: 11, day: 25, hour: 12
        )

        #expect(formatter.string(from: date).contains("Nov 25"))
    }

    @Test func usesTimeZoneOfCityNotDevice() throws {
        let instant = try makeDate(
            timeZoneIdentifier: "UTC",
            year: 2026, month: 11, day: 25, hour: 17
        )

        let singapore = ForecastDayFormatter(
            timeZoneIdentifier: "Asia/Singapore",
            locale: Locale(identifier: "en_US")
        )
        let utc = ForecastDayFormatter(
            timeZoneIdentifier: "UTC",
            locale: Locale(identifier: "en_US")
        )

        // UTC 17:00 在新加坡已经是次日 01:00
        #expect(singapore.string(from: instant).contains("Nov 26"))
        #expect(utc.string(from: instant).contains("Nov 25"))
    }

    private func makeDate(
        timeZoneIdentifier: String,
        year: Int,
        month: Int,
        day: Int,
        hour: Int
    ) throws -> Date {
        let timeZone = try #require(TimeZone(identifier: timeZoneIdentifier))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        return try #require(
            calendar.date(
                from: DateComponents(
                    year: year,
                    month: month,
                    day: day,
                    hour: hour
                )
            )
        )
    }
}

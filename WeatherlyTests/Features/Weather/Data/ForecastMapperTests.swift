//
//  Untitled.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import Foundation
import Testing
@testable import Weatherly

@MainActor
struct ForecastMapperTests {

    @Test func mapsValidResponse() throws {
        let weather = try ForecastMapper.map(makeDTO())
        let timeZone = try #require(TimeZone(identifier: "Asia/Singapore"))

        let currentTime = try makeDate(2026, 11, 25, 14, 30, in: timeZone)
        let firstDayDate = try makeDate(2026, 11, 25, in: timeZone)
        let lastDayDate = try makeDate(2026, 11, 26, in: timeZone)

        #expect(weather.timeZoneIdentifier == "Asia/Singapore")
        #expect(weather.current.time == currentTime)
        #expect(weather.current.temperature == 30.2)
        #expect(weather.current.condition == .partlyCloudy)

        #expect(weather.daily.count == 2)

        let firstDay = try #require(weather.daily.first)
        #expect(firstDay.date == firstDayDate)
        #expect(firstDay.minTemperature == 25)
        #expect(firstDay.maxTemperature == 31)
        #expect(firstDay.condition == .cloudy)

        let lastDay = try #require(weather.daily.last)
        #expect(lastDay.date == lastDayDate)
        #expect(lastDay.minTemperature == 26)
        #expect(lastDay.maxTemperature == 32)
        #expect(lastDay.condition == .rain)
    }

    @Test func throwsDecodingForInvalidTimeZone() {
        let dto = makeDTO(timeZone: "Nowhere/Nothing")

        #expect(throws: AppError.decoding) {
            try ForecastMapper.map(dto)
        }
    }

    @Test func throwsDecodingForInvalidCurrentTime() {
        let dto = makeDTO(currentTime: "not-a-date")

        #expect(throws: AppError.decoding) {
            try ForecastMapper.map(dto)
        }
    }

    @Test func throwsDecodingForInvalidDailyDate() {
        let dto = makeDTO(days: ["2026-11-25", "25/11/2026"])

        #expect(throws: AppError.decoding) {
            try ForecastMapper.map(dto)
        }
    }

    @Test func throwsDecodingWhenDailyArraysHaveDifferentCounts() {
        let dto = makeDTO(codes: [3])

        #expect(throws: AppError.decoding) {
            try ForecastMapper.map(dto)
        }
    }

    @Test(arguments: [
        (0, WeatherCondition.clear),
        (1, WeatherCondition.partlyCloudy),
        (2, WeatherCondition.partlyCloudy),
        (3, WeatherCondition.cloudy),
        (45, WeatherCondition.fog),
        (48, WeatherCondition.fog),
        (51, WeatherCondition.drizzle),
        (61, WeatherCondition.rain),
        (71, WeatherCondition.snow),
        (86, WeatherCondition.snow),
        (95, WeatherCondition.thunderstorm),
        (100, WeatherCondition.unknown)
    ])
    func mapsWeatherCode(
        _ code: Int,
        _ expected: WeatherCondition
    ) throws {
        let weather = try ForecastMapper.map(
            makeDTO(
                currentCode: code,
                days: ["2026-11-25"],
                codes: [code],
                maxTemperatures: [31],
                minTemperatures: [25]
            )
        )

        #expect(weather.current.condition == expected)
        #expect(weather.daily.first?.condition == expected)
    }
    
    private func makeDTO(
        timeZone: String = "Asia/Singapore",
        currentTime: String = "2026-11-25T14:30",
        currentCode: Int = 2,
        currentTemperature: Double = 30.2,
        days: [String] = ["2026-11-25", "2026-11-26"],
        codes: [Int] = [3, 61],
        maxTemperatures: [Double] = [31, 32],
        minTemperatures: [Double] = [25, 26]
    ) -> ForecastResponseDTO {
        ForecastResponseDTO(
            timeZone: timeZone,
            current: CurrentWeatherDTO(
                time: currentTime,
                temperature2m: currentTemperature,
                weatherCode: currentCode
            ),
            daily: DailyWeatherDTO(
                time: days,
                weatherCode: codes,
                temperature2mMax: maxTemperatures,
                temperature2mMin: minTemperatures
            )
        )
    }

    private func makeDate(
        _ year: Int,
        _ month: Int,
        _ day: Int,
        _ hour: Int = 0,
        _ minute: Int = 0,
        in timeZone: TimeZone
    ) throws -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return try #require(
            calendar.date(
                from: DateComponents(
                    year: year,
                    month: month,
                    day: day,
                    hour: hour,
                    minute: minute
                )
            )
        )
    }
}

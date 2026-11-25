//
//  ForecastMapper.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import Foundation

enum ForecastMapper {
    static func map(_ dto: ForecastResponseDTO) throws -> Weather {
        guard let timeZone = TimeZone(identifier: dto.timeZone) else {
            throw AppError.decoding
        }

        let dateTimeFormatter = makeFormatter(
            format: "yyyy-MM-dd'T'HH:mm",
            timeZone: timeZone
        )

        let dayFormatter = makeFormatter(
            format: "yyyy-MM-dd",
            timeZone: timeZone
        )

        guard let currentDate = dateTimeFormatter.date(
            from: dto.current.time
        ) else {
            throw AppError.decoding
        }

        let current = CurrentWeather(
            time: currentDate,
            temperature: dto.current.temperature2m,
            condition: condition(for: dto.current.weatherCode)
        )

        let dailyDTO = dto.daily
        let dayCount = dailyDTO.time.count

        guard dailyDTO.weatherCode.count == dayCount,
              dailyDTO.temperature2mMax.count == dayCount,
              dailyDTO.temperature2mMin.count == dayCount else {
            throw AppError.decoding
        }

        let daily = try dailyDTO.time.indices.map { index in
            guard let date = dayFormatter.date(
                from: dailyDTO.time[index]
            ) else {
                throw AppError.decoding
            }

            return DailyForecast(
                date: date,
                minTemperature: dailyDTO.temperature2mMin[index],
                maxTemperature: dailyDTO.temperature2mMax[index],
                condition: condition(
                    for: dailyDTO.weatherCode[index]
                )
            )
        }

        return Weather(
            current: current,
            daily: daily,
            timeZoneIdentifier: dto.timeZone
        )
    }

    private static func makeFormatter(
        format: String,
        timeZone: TimeZone
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter
    }

    private static func condition(for code: Int) -> WeatherCondition {
        switch code {
        case 0:
            return .clear
        case 1, 2:
            return .partlyCloudy
        case 3:
            return .cloudy
        case 45, 48:
            return .fog
        case 51, 53, 55, 56, 57:
            return .drizzle
        case 61, 63, 65, 66, 67, 80, 81, 82:
            return .rain
        case 71, 73, 75, 77, 85, 86:
            return .snow
        case 95, 96, 99:
            return .thunderstorm
        default:
            return .unknown
        }
    }
}

//
//  Weather.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import Foundation

struct Weather: Equatable {
    let current: CurrentWeather
        let daily: [DailyForecast]
        let timeZoneIdentifier: String
}

struct CurrentWeather: Equatable {
    let time: Date
    let temperature: Double
    let condition: WeatherCondition
}

struct DailyForecast: Equatable {
    let date: Date
    let minTemperature: Double
    let maxTemperature: Double
    let condition: WeatherCondition
}

enum WeatherCondition: Equatable {
    case clear
    case partlyCloudy
    case cloudy
    case fog
    case drizzle
    case rain
    case snow
    case thunderstorm
    case unknown
}

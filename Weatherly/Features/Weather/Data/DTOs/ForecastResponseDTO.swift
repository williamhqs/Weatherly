//
//  ForecastResponseDTO.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

struct ForecastResponseDTO: Decodable {
    let timeZone: String
    let current: CurrentWeatherDTO
    let daily: DailyWeatherDTO
    
    enum CodingKeys: String, CodingKey {
        case timeZone = "timezone"
        case current
        case daily
    }
}

struct CurrentWeatherDTO: Decodable {
    let time: String
    let temperature2m: Double
    let weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case weatherCode = "weather_code"
    }
}

struct DailyWeatherDTO: Decodable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
    }
}

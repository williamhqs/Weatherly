//
//  OpenMeteoWeatherRepository.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

struct OpenMeteoWeatherRepository: WeatherRepository {
    let client: HTTPClient
    
    func weather(for location: Location) async throws -> Weather {
        let responseDto: ForecastResponseDTO = try await client.send(.forecast(for: location))
        return try ForecastMapper.map(responseDto)
    }
}

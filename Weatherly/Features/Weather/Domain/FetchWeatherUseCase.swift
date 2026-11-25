//
//  FetchWeatherUseCase.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

struct FetchWeatherUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(for location: Location) async throws -> Weather {
        try await repository.weather(for: location)
    }
}

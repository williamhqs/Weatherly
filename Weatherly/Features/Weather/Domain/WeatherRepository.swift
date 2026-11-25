//
//  LocationRepository.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

protocol WeatherRepository {
    func weather(for location: Location) async throws -> Weather
}

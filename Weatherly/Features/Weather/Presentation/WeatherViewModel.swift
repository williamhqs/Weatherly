//
//  WeatherViewModel.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

import Observation

@MainActor
@Observable
final class WeatherViewModel {
    
    @ObservationIgnored let location: Location
    @ObservationIgnored private let fetchWeatherUseCase: FetchWeatherUseCase
    private(set) var fetchWeatherState: ViewState<Weather> = .idle
    
    init(location: Location, fetchWeatherUseCase: FetchWeatherUseCase) {
        self.location = location
        self.fetchWeatherUseCase = fetchWeatherUseCase
    }
    
    func load() async {
        if case .loading = fetchWeatherState {
            return
        }
        fetchWeatherState = .loading
        do {
            let weather = try await fetchWeatherUseCase.execute(for: location)
            fetchWeatherState = .loaded(weather)
        } catch let error as AppError {
            fetchWeatherState = .failed(error)
        } catch {
            fetchWeatherState = .failed(.unknown)
        }
    }
}

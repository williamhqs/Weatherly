//
//  AppContainer.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

@MainActor
final class AppContainer {
    private let httpClient: HTTPClient
    
    init() {
        self.httpClient = URLSessionHTTPClient()
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func makeWeatherViewModel(for location: Location) -> WeatherViewModel {
        WeatherViewModel(location: location, fetchWeatherUseCase: FetchWeatherUseCase(repository: OpenMeteoWeatherRepository(client: httpClient)))
    }
}

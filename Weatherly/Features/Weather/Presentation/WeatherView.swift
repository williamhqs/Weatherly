//
//  WeatherView.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

import SwiftUI

struct WeatherView: View {
    
    let viewModel: WeatherViewModel
    
    var body: some View {
        content
            .navigationTitle(viewModel.location.name)
            .task(id: viewModel.location.id) {
                await viewModel.load()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.fetchWeatherState {
        case .idle:
            Color.clear
        case .loading:
            ProgressView("Loading weather…")
        case .loaded(let weather):
            WeatherContentView(weather: weather)
        case .failed(let appError):
            WeatherErrorView(error: appError) {
                Task {
                    await viewModel.load()
                }
            }
        }
    }
}

#if DEBUG

private struct PreviewWeatherRepository: WeatherRepository {
    var result: Result<Weather, AppError> = .success(.preview)
    var delay: Duration = .zero
    
    func weather(for location: Location) async throws -> Weather {
        if delay > .zero {
            try? await Task.sleep(for: delay)
        }
        switch result {
        case .success(let weather):
            return weather
        case .failure(let error):
            throw error
        }
    }
}

private extension Weather {
    static var preview: Weather {
        let calendar = Calendar(identifier: .gregorian)
        let daily = (0..<7).map { offset in
            DailyForecast(
                date: calendar.date(
                    byAdding: .day,
                    value: offset,
                    to: .now
                ) ?? .now,
                minTemperature: 25.0 + Double(offset),
                maxTemperature: 31.0 + Double(offset),
                condition: offset % 3 == 0 ? .rain : .partlyCloudy
            )
        }
        
        return Weather(
            current: CurrentWeather(
                time: .now,
                temperature: 30.2,
                condition: .partlyCloudy
            ),
            daily: daily,
            timeZoneIdentifier: "Asia/Singapore"
        )
    }
}


@MainActor
private func previewViewModel(
    result: Result<Weather, AppError> = .success(.preview),
    delay: Duration = .zero
) -> WeatherViewModel {
    let repository = PreviewWeatherRepository(
        result: result,
        delay: delay
    )
    let useCase = FetchWeatherUseCase(repository: repository)
    return WeatherViewModel(location: .singapore, fetchWeatherUseCase: useCase)
}

#Preview("Loaded") {
    WeatherView(viewModel: previewViewModel())
}

#Preview("Loading") {
    WeatherView(
        viewModel: previewViewModel(delay: .seconds(60))
    )
}

#Preview("Error") {
    WeatherView(
        viewModel: previewViewModel(result: .failure(.offline))
    )
}
#endif

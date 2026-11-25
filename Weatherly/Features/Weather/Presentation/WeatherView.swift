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
        content.task {
            await viewModel.load()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.fetchWeatherState {
        case .idle:
            Color.red
        case .loading:
            ProgressView("Loading weather…")
        case .loaded(let weather):
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Weather")
                            .font(.headline)
                        Image(
                            systemName: weather.current.condition.systemImage
                        )
                        .font(.largeTitle)
                        Text(
                            String(
                                format: "%.1f °C",
                                weather.current.temperature
                            )
                        )
                        .font(.largeTitle)
                        
                        Text(weather.current.condition.title)
                            .foregroundStyle(.secondary)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("7-Day Forecast")
                            .font(.headline)
                        
                        ForEach(weather.daily, id: \.date) { day in
                            HStack {
                                Text(
                                    formattedDay(
                                        day.date,
                                        timeZoneIdentifier: weather.timeZoneIdentifier
                                    )
                                )
                                
                                Spacer()
                                
                                Image(systemName: day.condition.systemImage)
                                
                                Text(
                                    "\(Int(day.minTemperature.rounded()))° / \(Int(day.maxTemperature.rounded()))°"
                                )
                                .monospacedDigit()
                            }
                        }
                    }
                }
            }
            .padding()
        case .failed(let appError):
            VStack(spacing: 12) {
                Text(appError.message)
                    .multilineTextAlignment(.center)
                
                Button("Retry") {
                    Task {
                        await viewModel.load()
                    }
                }
            }
            .padding()
        }
    }
}

private func formattedDay(
    _ date: Date,
    timeZoneIdentifier: String
) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(
        identifier: timeZoneIdentifier
    )
    formatter.dateFormat = "E, MMM d"
    return formatter.string(from: date)
}

private extension AppError {
    var message: String {
        switch self {
        case .offline:
            return "No internet connection."
        case .timeout:
            return "The request timed out."
        case .server(let statusCode):
            return "Server error: \(statusCode)."
        case .decoding:
            return "The weather data could not be read."
        case .unknown:
            return "Something went wrong."
        }
    }
}


private extension WeatherCondition {
    var title: String {
        switch self {
        case .clear: return "Clear"
        case .partlyCloudy: return "Partly Cloudy"
        case .cloudy: return "Cloudy"
        case .fog: return "Fog"
        case .drizzle: return "Drizzle"
        case .rain: return "Rain"
        case .snow: return "Snow"
        case .thunderstorm: return "Thunderstorm"
        case .unknown: return "Unknown"
        }
    }
    
    var systemImage: String {
        switch self {
        case .clear: return "sun.max"
        case .partlyCloudy: return "cloud.sun"
        case .cloudy: return "cloud"
        case .fog: return "cloud.fog"
        case .drizzle: return "cloud.drizzle"
        case .rain: return "cloud.rain"
        case .snow: return "snow"
        case .thunderstorm: return "cloud.bolt.rain"
        case .unknown: return "questionmark.circle"
        }
    }
}


#if DEBUG
import SwiftUI

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

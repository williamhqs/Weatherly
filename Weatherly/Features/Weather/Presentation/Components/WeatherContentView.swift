//
//  WeatherContentView.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import SwiftUI

struct WeatherContentView: View {
    let weather: Weather
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                CurrentWeatherSection(current: weather.current)
                
                DailyForecastSection(
                    daily: weather.daily,
                    timeZoneIdentifier: weather.timeZoneIdentifier
                )
            }
            .padding()
        }
    }
}

#Preview {
    let calendar = Calendar(identifier: .gregorian)
    let daily = (0..<7).map { offset in
        DailyForecast(
            date: calendar.date(byAdding: .day, value: offset, to: .now) ?? .now,
            minTemperature: 25.0 + Double(offset),
            maxTemperature: 31.0 + Double(offset),
            condition: offset % 3 == 0 ? .rain : .partlyCloudy
        )
    }
    let mock = Weather(
        current: CurrentWeather(
            time: .now,
            temperature: 30.2,
            condition: .partlyCloudy
        ),
        daily: daily,
        timeZoneIdentifier: "Asia/Singapore")
    
    WeatherContentView(weather: mock)
}


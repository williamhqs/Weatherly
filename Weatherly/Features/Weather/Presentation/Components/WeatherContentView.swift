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
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Weather").font(.headline)
                    Image(systemName: weather.current.condition.systemImage)
                        .font(.largeTitle)
                    Text(String(format: "%.1f °C", weather.current.temperature))
                        .font(.largeTitle)
                    Text(weather.current.condition.title)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("7-Day Forecast").font(.headline)
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
                            Text("\(Int(day.minTemperature.rounded()))° / \(Int(day.maxTemperature.rounded()))°")
                                .monospacedDigit()
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func formattedDay(
        _ date: Date,
        timeZoneIdentifier: String
    ) -> String {
        var style = Date.FormatStyle()
            .weekday(.abbreviated)
            .month(.abbreviated)
            .day()
        
        style.timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .current
        
        return date.formatted(style)
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


//
//  DailyForecastSection.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import SwiftUI

struct DailyForecastSection: View {
    let daily: [DailyForecast]
    private let dayFormatter: ForecastDayFormatter
    
    init(daily: [DailyForecast], timeZoneIdentifier: String) {
        self.daily = daily
        self.dayFormatter = ForecastDayFormatter(
            timeZoneIdentifier: timeZoneIdentifier
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("7-Day Forecast")
                .font(.headline)

            ForEach(daily, id: \.date) { day in
                row(for: day)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func row(for day: DailyForecast) -> some View {
        HStack(spacing: 12) {
            Text(dayFormatter.string(from: day.date))
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: day.condition.systemImage)
                .frame(width: 24)

            Text("\(Int(day.minTemperature.rounded()))°")
                .monospacedDigit()
                .frame(width: 36, alignment: .trailing)

            Text("\(Int(day.maxTemperature.rounded()))°")
                .monospacedDigit()
                .frame(width: 36, alignment: .trailing)
        }
    }

}

#Preview {
    let daily = (0..<7).map { offset in
        DailyForecast(
            date: Calendar.current.date(byAdding: .day, value: offset, to: .now) ?? .now,
            minTemperature: 24.0 + Double(offset),
            maxTemperature: 30.0 + Double(offset),
            condition: offset % 2 == 0 ? .partlyCloudy : .rain
        )
    }

    DailyForecastSection(
        daily: daily,
        timeZoneIdentifier: "Asia/Singapore"
    )
    .padding()
    .frame(width: 380)
}

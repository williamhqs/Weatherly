//
//  CurrentWeatherSection.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import SwiftUI

struct CurrentWeatherSection: View {
    let current: CurrentWeather

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current Weather")
                .font(.headline)

            Image(systemName: current.condition.systemImage)
                .font(.largeTitle)

            Text(String(format: "%.1f °C", current.temperature))
                .font(.largeTitle)

            Text(current.condition.title)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CurrentWeatherSection(
        current: CurrentWeather(
            time: .now,
            temperature: 30.2,
            condition: .partlyCloudy
        )
    )
    .padding()
    .frame(width: 320)
}

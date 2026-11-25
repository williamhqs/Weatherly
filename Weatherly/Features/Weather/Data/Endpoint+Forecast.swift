//
//  Endpoint+Forecast.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//
import Foundation

extension Endpoint {
    static func forecast(for location: Location) -> Endpoint {
        Endpoint(baseURL: URL(string: "https://api.open-meteo.com")!,
                 path: "/v1/forecast",
                 queryItems: [
                    URLQueryItem(
                        name: "latitude",
                        value: String(location.latitude)
                    ),
                    URLQueryItem(
                        name: "longitude",
                        value: String(location.longitude)
                    ),
                    URLQueryItem(
                        name: "current",
                        value: "temperature_2m,weather_code"
                    ),
                    URLQueryItem(
                        name: "daily",
                        value: "weather_code,temperature_2m_max,temperature_2m_min"
                    ),
                    URLQueryItem(name: "forecast_days", value: "7"),
                    URLQueryItem(name: "timezone", value: "auto")])
    }
}

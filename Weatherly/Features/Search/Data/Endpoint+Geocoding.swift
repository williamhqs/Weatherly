//
//  Endpoint+Geocoding.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import Foundation

extension Endpoint {
    static func geocoding(query: String) -> Endpoint {
        Endpoint(
            baseURL: URL(string: "https://geocoding-api.open-meteo.com")!,
            path: "/v1/search",
            queryItems: [
                URLQueryItem(name: "name", value: query),
                URLQueryItem(name: "count", value: "10"),
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "format", value: "json")
            ]
        )
    }
}

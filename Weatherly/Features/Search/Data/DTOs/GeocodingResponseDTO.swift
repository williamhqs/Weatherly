//
//  GeocodingResponseDTO.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

struct GeocodingResponseDTO: Decodable {
    let results: [GeocodingResultDTO]?
}

struct GeocodingResultDTO: Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
}

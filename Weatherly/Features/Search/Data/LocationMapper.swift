//
//  GeocodingResponseMapper.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

enum LocationMapper {
    static func map(_ dto: GeocodingResponseDTO) -> [Location] {
        (dto.results ?? []).map { result in
            Location(
                id: String(result.id),
                name: result.name,
                region: result.admin1,
                country: result.country,
                latitude: result.latitude,
                longitude: result.longitude
            )
        }
    }
}

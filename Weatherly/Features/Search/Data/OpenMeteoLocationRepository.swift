//
//  OpenMeteoLocationRepository.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

struct OpenMeteoLocationRepository: LocationRepository {
    let client: HTTPClient

    func search(query: String) async throws -> [Location] {
        let responseDTO: GeocodingResponseDTO = try await client.send(
            .geocoding(query: query)
        )
        return LocationMapper.map(responseDTO)
    }
}

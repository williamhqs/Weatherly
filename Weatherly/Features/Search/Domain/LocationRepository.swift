//
//  LocationRepository.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

protocol LocationRepository {
    func search(query: String) async throws -> [Location]
}

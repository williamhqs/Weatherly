//
//  FetchWeatherUseCase.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

import Foundation

struct SearchLocationUseCase {
    private let repository: LocationRepository

    init(repository: LocationRepository) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [Location] {
        let trimmedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !trimmedQuery.isEmpty else {
            return []
        }
        return try await repository.search(query: trimmedQuery)
    }
}

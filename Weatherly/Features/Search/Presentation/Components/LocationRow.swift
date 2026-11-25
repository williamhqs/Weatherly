//
//  LocationRow.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import SwiftUI

struct LocationRow: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(location.name)
                .foregroundStyle(.primary)

            if let subtitle = Self.subtitle(for: location) {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    static func subtitle(for location: Location) -> String? {
        let parts = [location.region, location.country]
            .compactMap { $0 }
            .filter { !$0.isEmpty && $0 != location.name }

        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }
}

#Preview {
    List {
        LocationRow(location: .singapore)

        LocationRow(
            location: Location(
                id: "paris",
                name: "Paris",
                region: "Île-de-France",
                country: "France",
                latitude: 48.8566,
                longitude: 2.3522
            )
        )

        LocationRow(
            location: Location(
                id: "tokyo",
                name: "Tokyo",
                region: "Tokyo",
                country: "Japan",
                latitude: 35.6762,
                longitude: 139.6503
            )
        )
    }
    .frame(width: 320, height: 260)
}

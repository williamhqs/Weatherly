//
//  Location.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

struct Location: Identifiable, Hashable {
    let id: String
    let name: String
    let region: String?
    let country: String?
    let latitude: Double
    let longitude: Double
}

extension Location {
    static let singapore = Location(
        id: "sss",
        name: "Singapore",
        region: nil,
        country: "Singapore",
        latitude: 1.28967,
        longitude: 103.85007
    )
}

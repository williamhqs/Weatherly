//
//  HTTPClient.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

protocol HTTPClient {
    func send<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response
}

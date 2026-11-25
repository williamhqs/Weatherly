//
//  Endpoint.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

import Foundation

struct Endpoint {
    let baseURL: URL
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    
    init(baseURL: URL,
         path: String,
         method: HTTPMethod = .get,
         queryItems: [URLQueryItem] = [],
         headers: [String: String] = [:]) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
    }
}

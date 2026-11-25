//
//  AppError.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

enum AppError: Error, Equatable {
    case offline
    case timeout
    case server(statusCode: Int)
    case decoding
    case unknown
}

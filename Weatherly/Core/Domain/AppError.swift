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

extension AppError {
    var message: String {
        switch self {
        case .offline:
            return "No internet connection."
        case .timeout:
            return "The request timed out."
        case .server(let statusCode):
            return "Server error: \(statusCode)."
        case .decoding:
            return "The weather data could not be read."
        case .unknown:
            return "Something went wrong."
        }
    }
}

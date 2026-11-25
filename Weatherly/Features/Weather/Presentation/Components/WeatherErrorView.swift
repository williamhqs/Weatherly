//
//  WeatherErrorView.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import SwiftUI

struct WeatherErrorView: View {
    let error: AppError
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text(error.message)
                .multilineTextAlignment(.center)

            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Offline") {
    WeatherErrorView(error: .offline) {}
}

#Preview("Server") {
    WeatherErrorView(error: .server(statusCode: 503)) {}
}

private extension AppError {
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

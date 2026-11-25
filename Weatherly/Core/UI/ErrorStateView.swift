//
//  ErrorStateView.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    var systemImage: String = "exclamationmark.triangle"
    var retryTitle: String = "Retry"
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text(message)
                .multilineTextAlignment(.center)

            Button(retryTitle, action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Offline") {
    ErrorStateView(message: AppError.offline.message) {}
}

#Preview("Server") {
    ErrorStateView(message: AppError.server(statusCode: 503).message) {}
}

#Preview("Custom") {
    ErrorStateView(
        message: "Search is temporarily unavailable.",
        systemImage: "magnifyingglass",
        retryTitle: "Try Again"
    ) {}
}

#Preview {
    ErrorStateView(message: "The request timed out.", onRetry: {})
}

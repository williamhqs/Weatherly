//
//  SearchLocationView.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

import SwiftUI

struct SearchLocationView: View {
    @Bindable var viewModel: SearchLocationViewModel
    let onSelect: (Location) -> Void
    
    var body: some View {
        content
            .navigationTitle("Search Location")
            .searchable(text: $viewModel.query, prompt: "Search by city name")
            .onSubmit(of: .search) {
                Task { await viewModel.searchNow() }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.searchState {
        case .idle:
            ContentUnavailableView(
                "Search for a City",
                systemImage: "magnifyingglass",
                description: Text("Type a city name to see its weather.")
            )
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let locations) where locations.isEmpty:
            ContentUnavailableView.search(text: viewModel.query)
        case .loaded(let locations):
            List(locations) { location in
                Button {
                    onSelect(location)
                } label: {
                    row(for: location)
                }
            }
        case .failed(let error):
            VStack(spacing: 16) {
                Text(error.message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                Button("Retry") {
                    Task { await viewModel.searchNow() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func row(for location: Location) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(location.name)
                .foregroundStyle(.primary)
            if let subtitle = subtitle(for: location) {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
    
    private func subtitle(for location: Location) -> String? {
        let parts = [location.region, location.country]
            .compactMap { $0 }
            .filter { !$0.isEmpty && $0 != location.name }
        
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }
}

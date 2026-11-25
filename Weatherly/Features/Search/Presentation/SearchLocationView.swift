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
                    LocationRow(location: location)
                }
            }
        case .failed(let error):
            ErrorStateView(message: error.message) {
                Task { await viewModel.searchNow() }
            }
        }
    }
}

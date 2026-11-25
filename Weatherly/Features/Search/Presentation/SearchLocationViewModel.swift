//
//  SearchLocationViewModel.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

import Foundation
import Observation

@MainActor
@Observable
final class SearchLocationViewModel {
    var query: String = "" {
        didSet {
            guard query != oldValue else { return }
            scheduleSearch()
        }
    }
    
    private(set) var searchState: ViewState<[Location]> = .idle
    
    @ObservationIgnored private let searchUseCase: SearchLocationUseCase
    @ObservationIgnored private let debounceInterval: Duration
    @ObservationIgnored private var searchTask: Task<Void, Never>?
    
    init(
        searchUseCase: SearchLocationUseCase,
        debounceInterval: Duration = .milliseconds(300)
    ) {
        self.searchUseCase = searchUseCase
        self.debounceInterval = debounceInterval
    }
    
    func searchNow() async {
        searchTask?.cancel()
        searchTask = nil
        await performSearch()
    }
    
    private func scheduleSearch() {
        searchTask?.cancel()
        
        guard !trimmedQuery.isEmpty else {
            searchState = .idle
            return
        }
        
        searchTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await Task.sleep(for: debounceInterval)
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            await self.performSearch()
        }
    }
    
    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func performSearch() async {
        guard !trimmedQuery.isEmpty else {
            searchState = .idle
            return
        }
        
        searchState = .loading
        do {
            let locations = try await searchUseCase.execute(query: query)
            guard !Task.isCancelled else { return }
            searchState = .loaded(locations)
        } catch is CancellationError {
        } catch {
            guard !Task.isCancelled else { return }
            searchState = .failed((error as? AppError) ?? .unknown)
        }
    }
}

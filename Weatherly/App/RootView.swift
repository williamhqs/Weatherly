import SwiftUI

struct RootView: View {
    
    private let container: AppContainer
    
    @State private var weatherViewModel: WeatherViewModel
    @State private var searchViewModel: SearchLocationViewModel
    @State private var isSearching = false
    
    init(container: AppContainer) {
        self.container = container
        _weatherViewModel = State(initialValue: container.makeWeatherViewModel(for: .singapore))
        _searchViewModel = State(initialValue: container.makeSearchLocationViewModel())
    }
    
    var body: some View {
        NavigationStack {
            WeatherView(viewModel: weatherViewModel)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isSearching = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        .accessibilityLabel("Search Location")
                    }
                }
                .sheet(isPresented: $isSearching) {
                    NavigationStack {
                        SearchLocationView(viewModel: searchViewModel) { location in
                            weatherViewModel = container.makeWeatherViewModel(
                                for: location
                            )
                            isSearching = false
                        }
                        .modifier(SearchSheetSizing())
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isSearching = false
                                }
                            }
                        }
                    }
                }
        }
    }
}

private struct SearchSheetSizing: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .frame(
                minWidth: 420,
                idealWidth: 460,
                minHeight: 360,
                idealHeight: 460,
                maxHeight: 620
            )
        #else
        content
        #endif
    }
}

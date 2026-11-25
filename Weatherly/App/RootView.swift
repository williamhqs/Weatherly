import SwiftUI

struct RootView: View {
    
    @State private var viewModel: WeatherViewModel
    
    init(container: AppContainer) {
        _viewModel = State(initialValue: container.makeWeatherViewModel(for: .singapore))
    }
    
    var body: some View {
        VStack {
            SearchLocationView()
            WeatherView(viewModel: viewModel)
        }
    }
}

//#Preview {
//    RootView()
//}


import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            SearchLocationView()
            WeatherView()            
        }
    }
}

#Preview {
    RootView()
}


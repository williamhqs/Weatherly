//
//  WeatherView.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

import SwiftUI

struct WeatherView: View {
    
    let viewModel: WeatherViewModel
    
    var body: some View {
        Text("Weather View")
            .task {
                await viewModel.load()
            }
    }
}

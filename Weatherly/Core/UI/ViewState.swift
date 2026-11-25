//
//  ViewState.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/24.
//

enum ViewState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(AppError)
}

extension ViewState: Equatable where Value: Equatable { }


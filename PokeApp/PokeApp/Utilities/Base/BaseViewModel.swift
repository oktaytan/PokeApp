//
//  BaseViewModel.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

protocol BaseViewModel {
    func start()
}

enum ObservationType<T, E> {
    case updateUI(data: T? = nil), error(error: E?)
}

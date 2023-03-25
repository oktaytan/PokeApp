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

// ViewModel ile View arasındaki iletişimi sağlayan clousure içerisine event göndermek için kullanılır.
enum ObservationType<T, E> {
    case updateUI(data: T? = nil), error(error: E?)
}

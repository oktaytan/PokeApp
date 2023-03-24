//
//  RouterFlow.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

// MARK: - Controller to Coordinator event type
/// Coordinator ile Controller arasındaki iletişimi sağlar.
enum AppFlowEventType {
    case pokeDetail(id: Int), finishController
}

// MARK: Coordinator To Coordinator event type
/// Coordinatorler arası iletişimi sağlar. Sadece iki coordinator arasında kullanılır.
enum CoordinatorEventType {
    case finishCoordinator(coordinator: Coordinator)
}

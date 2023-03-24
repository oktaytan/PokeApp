//
//  PokeListCoordinator.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

final class PokeListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let pokeListVC = PokeListScreenBuilderImpl.build(coordinatorDelegate: self)
        self.navigationController.pushViewController(pokeListVC, animated: false)
    }
}

// MARK: - Controller To Coordinator
extension PokeListCoordinator: CommonControllerToCoordinatorDelegate {
    func commonControllerToCoordinator(eventType: AppFlowEventType) {
        switch eventType {
        case .pokeDetail(let id):
            goToPokeDetail(id: id)
        default:
            break
        }
    }
}

// MARK: - Coordinator To Coordinator
extension PokeListCoordinator {
    private func resetCoordinator(coordinator: Coordinator) {
        self.removeChild(coordinator: coordinator)
    }
    
    private func pokeDetailCoordinatorEvent(event: CoordinatorEventType) {
        switch event {
        case .finishCoordinator(let coordinator):
            resetCoordinator(coordinator: coordinator)
        }
    }
}

extension PokeListCoordinator {
    func goToPokeDetail(id: Int) {
        let pokeDetailCoordinator = PokeDetailCoordinator(navigationController: navigationController, pokeID: id)
        addChild(coordinator: pokeDetailCoordinator)
        pokeDetailCoordinator.callBack = { [weak self] event in
            self?.pokeDetailCoordinatorEvent(event: event)
        }
        
        pokeDetailCoordinator.start()
    }
}

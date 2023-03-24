//
//  PokeDetailCoordinator.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

final class PokeDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    var callBack: ((CoordinatorEventType) -> ())?
    var pokeID: Int
    
    init(navigationController: BaseNavigationController, pokeID: Int) {
        self.navigationController = navigationController
        self.pokeID = pokeID
    }
    
    func start() {
        let pokeDetailVC = PokeDetailBuilderImpl.build(pokeID: self.pokeID, coordinatorDelegate: self)
        self.navigationController.pushViewController(pokeDetailVC, animated: true)
    }
    
    func finishPokeDetailCoordinator() {
        callBack?(.finishCoordinator(coordinator: self))
    }
}


extension PokeDetailCoordinator: CommonControllerToCoordinatorDelegate {
    func commonControllerToCoordinator(eventType: AppFlowEventType) {
        switch eventType {
        case .pokeDetail(let id):
            goToPokeDetail(id: id)
        case .finishController:
            finishPokeDetailCoordinator()
        }
    }
}

// MARK: - Coordinator To Coordinator
extension PokeDetailCoordinator {
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

extension PokeDetailCoordinator {
    func goToPokeDetail(id: Int) {
        let pokeDetailCoordinator = PokeDetailCoordinator(navigationController: navigationController, pokeID: id)
        addChild(coordinator: pokeDetailCoordinator)
        pokeDetailCoordinator.callBack = { [weak self] event in
            self?.pokeDetailCoordinatorEvent(event: event)
        }
        
        pokeDetailCoordinator.start()
    }
}

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
    var pokeID: String
    
    init(navigationController: BaseNavigationController, pokeID: String) {
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
        case .finishController:
            finishPokeDetailCoordinator()
        default:
            break
        }
    }
}

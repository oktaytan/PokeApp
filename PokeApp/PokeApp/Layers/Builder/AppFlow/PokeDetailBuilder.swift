//
//  PokeDetailBuilder.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

protocol PokeDetailBuilder {
    static func build(pokeID: Int, coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController
}

struct PokeDetailBuilderImpl: PokeDetailBuilder {
    static func build(pokeID: Int, coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController {
        let vc = PokeDetailVC(nibName: PokeDetailVC.className, bundle: nil)
        vc.coordinatorDelegate = coordinatorDelegate
        
        let repo = PokeRepositoryImpl()
        let pokeStore = PokeDataStoreImpl(repo: repo)
        let abilityStore = AbilityDataStoreImpl(repo: repo)
        let viewModel = PokeDetailViewModelImpl(id: pokeID, pokeStore: pokeStore, abilityStore: abilityStore)
        let provider = PokeDetailCollectionViewProviderImpl()
        
        vc.inject(viewModel: viewModel, provider: provider)
        
        return vc
    }
}

//
//  PokeListScreenBuilder.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

protocol PokeListScreenBuilder {
    static func build(coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController
}

/// Pokemon listesinin gösterileceği ekranı yaratır ve bağımlılıklarını inject eder.
struct PokeListScreenBuilderImpl: PokeListScreenBuilder {
    static func build(coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController {
        let vc = PokeListVC(nibName: PokeListVC.className, bundle: nil)
        vc.coordinatorDelegate = coordinatorDelegate
        
        let repo = PokeRepositoryImpl()
        let store = PokeDataStoreImpl(repo: repo)
        let viewModel = PokeListViewModelImpl(store: store)
        let provider = PokeTableViewImpl()
        
        vc.inject(viewModel: viewModel, provider: provider)
        
        return vc
    }
}

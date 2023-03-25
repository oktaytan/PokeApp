//
//  PokeDetailVC.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

protocol CollectionControllerBehaviorally {
    associatedtype V
    associatedtype P
    func inject(viewModel: V, provider: P)
    func addObservationListener()
    func setupCollectionView()
}

final class PokeDetailVC: BaseViewController, CollectionControllerBehaviorally {
    
    typealias V = PokeDetailViewModel
    typealias P = PokeDetailCollectionViewProvider
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: V!
    private var provider: P!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        addObservationListener()
        viewModel.start()
    }
    
    override func setupView() {
        self.setupNavBar(title: nil, leftIcon: "left-arrow-white-icon", rightIcon: nil, leftItemAction: #selector(goToList))
    }
    
    deinit {
        coordinatorDelegate?.commonControllerToCoordinator(eventType: .finishController)
    }
    
    @objc func goToList() {
        self.goBack()
    }
    
    /// Controller'a ViewModel ve Provider inject eder.
    /// - Parameters:
    ///   - viewModel: PokeDetailViewModel
    ///   - provider: PokeDetailCollectionViewProvider
    func inject(viewModel: V, provider: P) {
        self.viewModel = viewModel
        self.provider = provider
    }
    
    func setupCollectionView() {
        provider.setupCollectionView(collectionView: self.collectionView)
    }
    
    private func handleError(message: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.showToastMessage(title: AppConstants.AppTitle, message: message, type: .error)
        }
    }
    
    private func handleLoading(show: Bool) {
        show ? self.showLoading() : self.hideLoading()
    }
}


// MARK: - Listeners
extension PokeDetailVC {
    func addObservationListener() {
        /// ViewModel listener
        self.viewModel.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                guard let data = data else { return }
                self?.handleClosureData(data: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
        
        /// TableView provider listener
        self.provider.collectionViewStateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.collectionViewUserActivity(event: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
    }
}


// MARK: - ViewModel Event Handler
extension PokeDetailVC {
    private func handleClosureData(data: PokeDetailViewModelImpl.UserInteractivity) {
        DispatchQueue.main.async { [weak self] in
            switch data {
            case .updateData(let data):
                self?.provider.setData(data: data)
            case .loading(let show):
                self?.handleLoading(show: show)
            case .error(let message):
                self?.handleError(message: message)
            }
        }
    }
}


// MARK: - CollectionView Provider Event Handler
extension PokeDetailVC {
    private func collectionViewUserActivity(event: PokeDetailCollectionViewProviderImpl.CollectionViewUserInteractivity?) {
        guard let event = event else { return }
        switch event {
        case .showEffect(let effect):
            showToastMessage(title: nil, message: effect.shortEffect, type: .success)
        case .goToPokemon(let id):
            coordinatorDelegate?.commonControllerToCoordinator(eventType: .pokeDetail(id: id))
        }
    }
}

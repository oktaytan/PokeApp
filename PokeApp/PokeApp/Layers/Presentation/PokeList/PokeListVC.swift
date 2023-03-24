//
//  PokeListVC.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

protocol ListControllerBehaviorally {
    associatedtype V
    associatedtype P
    func inject(viewModel: V, provider: P)
    func addObservationListener()
    func setupTableView()
}

final class PokeListVC: BaseViewController, ListControllerBehaviorally {
    
    typealias V = PokeListViewModel
    typealias P = PokeTableViewProvider
    
    var viewModel: V!
    private var provider: P!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addObservationListener()
        viewModel.start()
    }
    
    override func setupView() {
        super.setupView()
        self.title = AppConstants.AppTitle
    }
    
    func inject(viewModel: V, provider: P) {
        self.viewModel = viewModel
        self.provider = provider
    }
    
    func setupTableView() {
        provider.setupTableView(tableView: tableView)
    }
    
    private func handleError(message: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.showToastMessage(title: AppConstants.AppTitle, message: message, type: .error)
        }
    }
    
    private func handleLoading(show: Bool, type: LoadingType) {
        switch type {
        case .fullpage:
            show ? self.showLoading() : self.hideLoading()
        case .prefetch:
            show ? self.showLoading() : self.hideLoading()
        }
    }
}


// MARK: - Listeners
extension PokeListVC {
    // Observation Listener
    func addObservationListener() {
        self.viewModel.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                guard let data = data else { return }
                self?.handleClosureData(data: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
        
        /// TableView provider Listener
        self.provider.tableViewStateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.tableViewUserActivity(event: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
    }
}


// MARK: - ViewModel Event Handler
extension PokeListVC {
    private func handleClosureData(data: PokeListViewModelImpl.UserInteractivity) {
        DispatchQueue.main.async { [weak self] in
            switch data {
            case .updateData(let data):
                self?.provider.setData(data: data)
            case .loading(let show, let type):
                self?.handleLoading(show: show, type: type)
            case .error(let message):
                self?.handleError(message: message)
            }
        }
    }
}


// MARK: - TableView Provider Event Handler
extension PokeListVC {
    private func tableViewUserActivity(event: PokeTableViewImpl.TableViewUserInteractivity?) {
        guard let event = event else { return }
        switch event {
        case .didSelectPokemon(let id):
            self.coordinatorDelegate?.commonControllerToCoordinator(eventType: .pokeDetail(id: id))
        case .fetchMore:
            self.viewModel.fetchPokemonList(next: true)
        }
    }
}




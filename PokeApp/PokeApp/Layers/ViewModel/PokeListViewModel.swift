//
//  PokeListViewModel.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

protocol PokeListViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((ObservationType<PokeListViewModelImpl.UserInteractivity, Error>) -> ())? { set get }
    
    /// ViewModel' in  ihtiyacı olan bağımlılıkarını inject eder.
    init(store: PokeDataStore)
    
    /// Ekran viewDidLoad olduğunda viewmodel' de yapılması gerekenler burda yapılır.
    func start()
    
    func fetchPokemonList(next: Bool)
}

final class PokeListViewModelImpl: BaseViewModel, PokeListViewModel {
    
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    
    private let store: PokeDataStore
    private var rows: [RowType] = []
    
    init(store: PokeDataStore) {
        self.store = store
    }
    
    func start() {
        fetchPokemonList(next: false)
    }
}


extension PokeListViewModelImpl {
    enum RowType {
        case pokemon(data: Pokemon), empty
    }
    
    enum UserInteractivity {
        case updateData(data: [RowType]), error(message: String?), loading(show: Bool, type: LoadingType)
    }
}


extension PokeListViewModelImpl {
    func fetchPokemonList(next: Bool) {
        self.stateClosure?(.updateUI(data: .loading(show: true, type: next ? .prefetch : .fullpage)))
        store.getPokeList(next: next) { pokemonList, error in
            self.stateClosure?(.updateUI(data: .loading(show: false, type: next ? .prefetch : .fullpage)))
            
            guard error == nil else {
                self.stateClosure?(.error(error: error))
                self.prepareUI(pokemonList: nil, next: next)
                return
            }
            
            guard let pokemonList = pokemonList else {
                self.prepareUI(pokemonList: nil, next: next)
                return
            }
            
            self.prepareUI(pokemonList: pokemonList, next: next)
        }
    }
    
    private func prepareUI(pokemonList: [Pokemon]?, next: Bool) {
        if !next {
            rows.removeAll()
        }
        
        guard let pokemonList = pokemonList else {
            rows = [RowType.empty]
            self.stateClosure?(.updateUI(data: .updateData(data: rows)))
            return
        }
        
        pokemonList.forEach { pokemon in
            rows.append(RowType.pokemon(data: pokemon))
        }
        
        self.stateClosure?(.updateUI(data: .updateData(data: rows)))
    }
}

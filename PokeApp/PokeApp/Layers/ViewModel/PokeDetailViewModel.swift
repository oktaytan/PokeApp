//
//  PokeDetailViewModel.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

protocol PokeDetailViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((ObservationType<PokeDetailViewModelImpl.UserInteractivity, Error>) -> ())? { set get }
    
    /// ViewModel' in ihtiyacı olan bağımlılıkarını inject eder.
    init(id: Int, pokeStore: PokeDataStore, abilityStore: AbilityDataStore)
    
    /// Ekran viewDidLoad olduğunda viewmodel' de yapılması gerekenler burda yapılır.
    func start()
}

final class PokeDetailViewModelImpl: BaseViewModel, PokeDetailViewModel {
    
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    
    private let id: Int
    private let pokeStore: PokeDataStore
    private let abilityStore: AbilityDataStore
    private var sections = [SectionType]()
    private var serviceGroup: DispatchGroup?
    private var pokemonDetail: PokemonDetail?
    private var types = [TypeElement]()
    private var abilityDetail = [AbilityDetail]()
    
    init(id: Int, pokeStore: PokeDataStore, abilityStore: AbilityDataStore) {
        self.id = id
        self.pokeStore = pokeStore
        self.abilityStore = abilityStore
    }
    
    func start() {
        fetchPageUIServices()
    }
    
    /// Servis isteğini DispatchGroup ile başlatır.
    private func fetchPageUIServices() {
        serviceGroup = DispatchGroup()
        fetchPokemonDetail(id: self.id)
        notifyServiceGroupListener()
    }
}


extension PokeDetailViewModelImpl {
    enum SectionType {
        case pokemon(rows: [RowType]), ability(data: [AbilityDetail]), types(data: [TypeElement])
    }
    
    enum RowType {
        case image(id: Int), name(name: String)
    }
    
    enum UserInteractivity {
        case updateData(data: [SectionType]), error(message: String?), loading(show: Bool)
    }
}


extension PokeDetailViewModelImpl {
    private func fetchPokemonDetail(id: Int) {
        serviceGroup?.enter()
        self.stateClosure?(.updateUI(data: .loading(show: true)))
        pokeStore.getPokeDetail(id: id) { [weak self] result, error in
            guard error == nil else {
                self?.serviceGroup?.leave()
                self?.stateClosure?(.error(error: error))
                return
            }
            
            self?.pokemonDetail = result
            if let types = result?.types {
                self?.types = types
            }
            
            self?.fetchAbilityDetail()
            self?.serviceGroup?.leave()
        }
    }
    
    private func fetchAbilityDetail() {
        guard let pokemonDetail = pokemonDetail else {
            self.stateClosure?(.updateUI(data: .loading(show: false)))
            return
        }
        
        pokemonDetail.abilities.forEach { item in
            serviceGroup?.enter()
            abilityStore.getAbilityList(id: item.ability.id) { [weak self] result, error in
                guard error == nil else {
                    self?.serviceGroup?.leave()
                    self?.stateClosure?(.error(error: error))
                    return
                }
                
                guard let abilityDetail = result else {
                    self?.abilityDetail = []
                    self?.serviceGroup?.leave()
                    return
                }
                
                self?.stateClosure?(.updateUI(data: .loading(show: false)))
                self?.abilityDetail.append(abilityDetail)
                self?.serviceGroup?.leave()
            }
        }
    }
    
    /// Servis isteği tamamlandığında datayı hazırlar.
    private func notifyServiceGroupListener() {
        serviceGroup?.notify(queue: .main) { [weak self] in
            self?.serviceGroup = nil
            self?.prepareUI()
        }
    }
    
    private func prepareUI() {
        self.sections.removeAll()
        
        if let pokemon = self.pokemonDetail {
            let pokemonSection = SectionType.pokemon(rows: [RowType.image(id: pokemon.id),
                                                            RowType.name(name: pokemon.name)])
            sections.append(pokemonSection)
        }
        
        if !self.abilityDetail.isEmpty {
            sections.append(SectionType.ability(data: abilityDetail))
        }
        
        if !self.types.isEmpty {
            sections.append(SectionType.types(data: self.types))
        }
        
        self.stateClosure?(.updateUI(data: .updateData(data: self.sections)))
    }
}

//
//  PokeRepository.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

protocol PokeRepository {
    func list(limit: Int, offset: Int, completion: @escaping PokeRepositoryImpl.PokeListCompletionType)
    func detail(id: Int, completion: @escaping PokeRepositoryImpl.PokeDetailCompletionType)
    func ability(id: Int, completion: @escaping PokeRepositoryImpl.PokeAbilityCompletionType)
}


struct PokeRepositoryImpl: PokeRepository {
    
    typealias PokeListCompletionType = (PokemonList?, Error?) -> Void
    typealias PokeDetailCompletionType = (PokemonDetail?, Error?) -> Void
    typealias PokeAbilityCompletionType = (AbilityDetail?, Error?) -> Void
    
    
    func list(limit: Int, offset: Int, completion: @escaping PokeListCompletionType) {
        APIHandler.shared.processRequest(target: Endpoint.list(limit: limit, offset: offset)).done { (response: PokemonList) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
    
    func detail(id: Int, completion: @escaping PokeDetailCompletionType) {
        APIHandler.shared.processRequest(target: Endpoint.detail(id: id)).done { (response: PokemonDetail) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
    
    func ability(id: Int, completion: @escaping PokeAbilityCompletionType) {
        APIHandler.shared.processRequest(target: Endpoint.ability(id: id)).done { (response: AbilityDetail) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
}

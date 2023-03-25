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
    
    
    /// Servisten limit ve offset parametreleri ile pokemon listesini döner.
    /// - Parameters:
    ///   - limit: Tek istekte kaç adet item getirileceğini belirler. - Int
    ///   - offset: Listenin hangi indexten başlayacağını belirler. - Int
    ///   - completion: Pokemon dizisi ve error dönen closure.
    func list(limit: Int, offset: Int, completion: @escaping PokeListCompletionType) {
        APIHandler.shared.processRequest(target: Endpoint.list(limit: limit, offset: offset)).done { (response: PokemonList) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
    
    /// Servisten belirli id ile pokemon detay verisini döner.
    /// - Parameters:
    ///   - id: Pokemon id
    ///   - completion: Pokemon verisi ve error dönen closure.
    func detail(id: Int, completion: @escaping PokeDetailCompletionType) {
        APIHandler.shared.processRequest(target: Endpoint.detail(id: id)).done { (response: PokemonDetail) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
    
    /// Servisten belirli pokemana ait yeteneğin detaylarını döner.
    /// - Parameters:
    ///   - id: Ability id
    ///   - completion: AbilityDetail ve Error dönen closure.
    func ability(id: Int, completion: @escaping PokeAbilityCompletionType) {
        APIHandler.shared.processRequest(target: Endpoint.ability(id: id)).done { (response: AbilityDetail) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
}

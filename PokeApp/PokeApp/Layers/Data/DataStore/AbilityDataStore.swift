//
//  AbilityDataStore.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

protocol AbilityDataStore {
    func getAbilityList(id: Int, completion: @escaping AbilityDataStoreImpl.AbilitiesCompletionType)
}


final class AbilityDataStoreImpl: AbilityDataStore {
    
    typealias AbilitiesCompletionType = (AbilityDetail?, Error?) -> Void
    
    private let repo: PokeRepository
    
    init(repo: PokeRepository) {
        self.repo = repo
    }
    
    /// Belirli ability id ile yetenek detya verisini döner.
    /// - Parameters:
    ///   - id: Ability id
    ///   - completion: AbilityDetail ve error dönen closure.
    func getAbilityList(id: Int, completion: @escaping AbilityDataStoreImpl.AbilitiesCompletionType) {
        repo.ability(id: id) { results, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let results = results else {
                completion(nil, nil)
                return
            }
            
            completion(results, nil)
        }
    }
}

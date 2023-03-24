//
//  PokeDataStore.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

protocol PokeDataStore {
    var page: Int { get set }
    var limit: Int { get set }
    var offset: Int { get set }
    
    func setDataConfiguration(limit: Int, offset: Int)
    func getPokeList(next: Bool, completion: @escaping PokeDataStoreImpl.PokeListCompletionType)
    func getPokeDetail(id: Int, completion: @escaping PokeDataStoreImpl.PokeDetailCompletionType)
}


final class PokeDataStoreImpl: PokeDataStore {
    
    typealias PokeListCompletionType = ([Pokemon]?, Error?) -> Void
    typealias PokeDetailCompletionType = (PokemonDetail?, Error?) -> Void
    
    private let repo: PokeRepository
    var page = 0
    var limit = 20
    var offset = 20
    
    init(repo: PokeRepository) {
        self.repo = repo
    }
    
    func setDataConfiguration(limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
    }
    
    func getPokeList(next: Bool, completion: @escaping PokeListCompletionType) {
        
        if next {
            self.page += 1
        }
        
        repo.list(limit: self.limit, offset: self.offset * page, completion: { pokeList, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let results = pokeList?.results else {
                completion([], nil)
                return
            }
            
            completion(results, nil)
        })
    }
    
    func getPokeDetail(id: Int, completion: @escaping PokeDetailCompletionType) {
        repo.detail(id: id) { results, error in
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

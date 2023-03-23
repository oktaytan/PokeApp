//
//  PokemonListModel.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import Foundation

struct PokemonList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

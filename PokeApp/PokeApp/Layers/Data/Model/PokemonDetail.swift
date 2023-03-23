//
//  PokemonDetail.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let abilities: [Ability]
}

// MARK: - Ability
struct Ability: Codable {
    let ability: Species
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

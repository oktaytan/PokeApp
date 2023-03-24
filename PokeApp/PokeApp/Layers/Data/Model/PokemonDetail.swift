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
    let types: [TypeElement]
}

// MARK: - Abilities
struct Ability: Codable {
    let ability: Species
    let isHidden: Bool
    let slot: Int
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

// MARK: - Species
struct Species: Codable {
    let id: Int
    let name: String
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        self.id = Int((self.url as NSString).lastPathComponent) ?? 1
    }
}

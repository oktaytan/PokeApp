//
//  AbilityDetail.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 24.03.2023.
//

import Foundation

struct AbilityDetail: Codable {
    let id: Int
    let name: String
    let effectEntries: [EffectEntry]

    enum CodingKeys: String, CodingKey {
        case effectEntries = "effect_entries"
        case id, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.effectEntries = try container.decode([EffectEntry].self, forKey: .effectEntries).filter({ $0.language.name == "en" })
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

// MARK: - EffectEntry
struct EffectEntry: Codable {
    let effect: String
    let language: Generation
    let shortEffect: String

    enum CodingKeys: String, CodingKey {
        case effect, language
        case shortEffect = "short_effect"
    }
}

// MARK: - Generation
struct Generation: Codable {
    let name: String
    let url: String
}

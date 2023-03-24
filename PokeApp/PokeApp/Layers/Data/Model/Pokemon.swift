//
//  Pokemon.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import Foundation

struct Pokemon: Codable {
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

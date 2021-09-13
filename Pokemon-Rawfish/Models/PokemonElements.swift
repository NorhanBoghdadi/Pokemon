//
//  PokemonElements.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/11/21.
//


import Foundation

// MARK: - PokemonElements
struct PokemonElements: Codable {
    let count: Int
    let next: String
    let previous: JSONNull?
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let url: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    func hash(into hasher: inout Hasher) {
       
    }
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

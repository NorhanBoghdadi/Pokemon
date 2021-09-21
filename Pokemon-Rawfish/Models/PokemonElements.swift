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
    let results: [PokemonResult]
    
}

// MARK: - Result
struct PokemonResult: Codable {
    let name: String
    let url: String
}


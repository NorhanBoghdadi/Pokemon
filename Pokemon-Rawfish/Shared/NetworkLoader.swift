//
//  NetworkLoader.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 11/22/21.
//

import Foundation
import Combine

protocol APIService {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, APIError>
}
protocol RequestBuilder {
    var urlRequest: URLRequest {get}
}
enum APIError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}

class APISession: APIService {
        
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, APIError> {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // 2
        return URLSession.shared
            .dataTaskPublisher(for: builder.urlRequest)
                    // 3
            .receive(on: DispatchQueue.main)
                    // 4
            .mapError { _ in .unknown }
                    // 5
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                            // 6
                        return Just(data)
                            .decode(type: T.self, decoder: decoder)
                            .mapError {_ in .decodingError}
                            .eraseToAnyPublisher()
                    } else {
                            // 7
                        return Fail(error: APIError.httpError(response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                    return Fail(error: APIError.unknown)
                        .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

    }
}

enum PokemonEndpoint {
    case pokemonList
}

extension PokemonEndpoint: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .pokemonList:
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon")
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
        }
        
    }
}
protocol PokemonService {
    var apiSession: APIService {get}
    
    func getPokemonList() -> AnyPublisher<PokemonElements, APIError>
}

extension PokemonService {
    
    func getPokemonList() -> AnyPublisher<PokemonElements, APIError> {
        return apiSession.request(with: PokemonEndpoint.pokemonList)
            .eraseToAnyPublisher()
    }
}

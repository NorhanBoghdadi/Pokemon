////
////  HomeGetPokemons.swift
////  Pokemon-Rawfish
////
////  Created by Norhan Boghdadi on 9/27/21.
////
//
//import Foundation
//
//
//class HomeGetPokemons {
//    
//    var pokemonElement = [PokemonResult]()
//    
//    //MARK: - Handle Networking
//    
//    func make(request withURL: URL) {
//        var request = URLRequest(url: withURL)
//        request.httpMethod = "GET"
//        send(request: request)
//    }
//    
//    func handle(respone: (Data?, URLResponse?, Error?))   {
//        guard let data = respone.0 else { return }
//        do {
//            pokemonElement = try process(data: data)
////            updateUI()
//        } catch {
//          
//        }
//    }
//    
//    func send(request: URLRequest) {
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config, delegate: nil, delegateQueue:OperationQueue.main)
//        let task = session.dataTask(with: request) {[weak self] (data, response, error) in
//            self?.handle(respone: (data, response, error))
//        }
//        task.resume()
//    }
//    
//    func process(data: Data) throws ->  [PokemonResult] {
//        let jsonData = try JSONDecoder().decode(PokemonElements.self, from: data)
////        return sortArr(arr: jsonData.results)
//        return jsonData.results
//    }
//    
//}
//
//

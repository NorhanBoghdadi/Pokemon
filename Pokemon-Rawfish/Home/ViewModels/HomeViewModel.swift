//
//  HomeViewModel.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/27/21.
//

import UIKit


class HomeViewModel: ViewModel  {
    
    let imageLoader = ImageLoader()

    let imgLink = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
    let dataUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    var loadedImg: UIImage?
    var cellImg: UIImage {
        loadedImg ?? UIImage(named: "2")!
    }

    
    var numberOfPokemons: Int {
        pokemonElement.count
    }
    
    var pokemonElement = [PokemonResult]()
    
    
    var viewController: DataLoaderController?
    
    
    init(viewController: DataLoaderController) {
        self.viewController = viewController
        DispatchQueue.main.async {
            viewController?.dataLoaded()
        }
        make(request: dataUrl)
        
    }
    
    
    
    
    
    // MARK: - Functions
    func data(for cellAt: IndexPath) -> PokemonResult {
        pokemonElement[cellAt.row]
    }
    
    func loadImage(){
        guard let imgUrl = URL(string: imgLink) else {
            return
        }
        imageLoader.loadImage(url: imgUrl) { results in
            switch results {
            case .success(let image):
                self.loadedImg = image
                 print(image)
                self.viewController??.dataLoaded()
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            
        }
    }
    
    func make(request withURL: URL) {
        var request = URLRequest(url: withURL)
        request.httpMethod = "GET"
        send(request: request)
    }
    
    func handle(respone: (Data?, URLResponse?, Error?))   {
        guard let data = respone.0 else { return }
        do {
            pokemonElement = try process(data: data)
            viewController??.dataLoaded()
        } catch {
          
        }
    }
    
    func send(request: URLRequest) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) {[weak self] (data, response, error) in
            self?.handle(respone: (data, response, error))
        }
        task.resume()
    }
    
    func process(data: Data) throws ->  [PokemonResult] {
        let jsonData = try JSONDecoder().decode(PokemonElements.self, from: data)
        return sortArr(arr: jsonData.results)
//        return jsonData.results
    }

   
    func sortArr(arr: [PokemonResult]) -> [PokemonResult] {
        return arr.sorted {
            $0.name < $1.name
        }
    }
    
}

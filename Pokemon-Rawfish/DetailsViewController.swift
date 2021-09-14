//
//  DetailsViewController.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/13/21.
//

import UIKit

class DetailsViewController: UIViewController {

    var url = " "
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .red
    }
    

//    func getPokemons(){
//
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "GET"
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config, delegate: nil, delegateQueue:OperationQueue.main)
//        let task = session.dataTask(with: request) { (data, response, error) in
//            if (error != nil){
//                print("error")
//            }
//
//            guard let data = data else { return }
//
//            do {
//                let jsonData = try JSONDecoder().decode(PokemonElements.self, from: data)
//                self.pokemonElement = jsonData.results
//
//
//                DispatchQueue.main.async {
//                    self.pokemonsTableView.reloadData()
//                }
//
//            }
//            catch {
//                print(error)
//            }
//
//
//        }
//
//        task.resume()
//
//    }
//
}

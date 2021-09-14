//
//  DetailsViewController.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/13/21.
//

import UIKit

class DetailsViewController: UIViewController {

    var url = " "
    var moves = [Move]()
    var imageUrl = " "
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        getPokemonsDetails()
    }
    

    func getPokemonsDetails(){

        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "GET"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil){
                print("error")
            }

            guard let data = data else { return }

            do {
                let jsonData = try JSONDecoder().decode(PokemonDetails.self, from: data)
                self.moves = jsonData.moves
                self.imageUrl = (jsonData.sprites.other?.officialArtwork.frontDefault)!
//                print(self.moves)
                print(self.imageUrl)
            
                DispatchQueue.main.async {
//                    self.pokemonsTableView.reloadData()
                }

            }
            catch {
                print(error)
            }


        }

        task.resume()

    }

}

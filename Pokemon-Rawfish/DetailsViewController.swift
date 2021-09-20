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
    var pokemonName: String!
    let cellReuseIden = "ReuseIden"
    
    private var nameLabel: UILabel!
    private var pokemonImage: UIImageView!
    private var movesTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let newTopView = UIView(frame: CGRect(x: 0, y: 0 , width: Int(view.frame.width), height: Int(view.frame.height) / 3 ))
        
        newTopView.backgroundColor = .darkGray
        newTopView.layer.cornerRadius = 10
        view.addSubview(newTopView)
        
        
        pokemonImage = UIImageView()
        pokemonImage.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        pokemonImage.layer.cornerRadius = pokemonImage.layer.bounds.width / 2
        pokemonImage.center.x = newTopView.bounds.midX
        pokemonImage.center.y = newTopView.bounds.midY
        pokemonImage.clipsToBounds = true
        pokemonImage.layer.borderColor = UIColor.darkGray.cgColor
        pokemonImage.layer.borderWidth = 2.0
        pokemonImage.image = UIImage(named: "p2")
        pokemonImage.backgroundColor = .white
        newTopView.addSubview(pokemonImage)
        
        nameLabel = UILabel()
        nameLabel.text = pokemonName
        nameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        newTopView.addSubview(nameLabel)
        
        movesTableView = UITableView()
        movesTableView.frame = CGRect(x: 0, y: newTopView.frame.height, width: view.frame.width, height: (view.frame.height) * 0.6)
        movesTableView.backgroundColor = .black
        movesTableView.delegate = self
        movesTableView.dataSource = self
        movesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIden)
        view.addSubview(movesTableView)
        
        getPokemonsDetails()
    }
    

    func getPokemonsDetails(){

        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "GET"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            if (error != nil){
                print("error")
            }

            guard let data = data else { return }

            do {
                let jsonData = try JSONDecoder().decode(PokemonDetails.self, from: data)
                self.moves = jsonData.moves
                self.imageUrl = (jsonData.sprites.other?.officialArtwork.frontDefault)!
            
                
                DispatchQueue.main.async {
                    self.movesTableView.reloadData()
                }

            }
            catch {
                print(error)
            }


        }

        task.resume()

    }

}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellReuseIden)
        cell.textLabel?.text = moves[indexPath.row].move.name
        return cell
        
    }
    
    
}

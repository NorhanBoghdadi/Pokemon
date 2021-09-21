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
    var activityIndicator = UIActivityIndicatorView(style: .large)

        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let newTopView = UIView(frame: CGRect(x: 0, y: 0 , width: Int(view.frame.width), height: Int(view.frame.height) / 3 ))
        
        newTopView.backgroundColor = .black
        newTopView.layer.cornerRadius = 10
        view.addSubview(newTopView)
        
        
        pokemonImage = UIImageView()
        pokemonImage.frame = CGRect(x: 0, y: 0, width: (newTopView.frame.height) / 2, height: (newTopView.frame.height) / 2)
        pokemonImage.layer.cornerRadius = pokemonImage.layer.bounds.width / 2
        pokemonImage.center.x = newTopView.bounds.midX
        pokemonImage.center.y = newTopView.bounds.midY
        pokemonImage.clipsToBounds = true
        pokemonImage.layer.borderColor = UIColor.darkGray.cgColor
        pokemonImage.layer.borderWidth = 2.0
        pokemonImage.backgroundColor = .white
        newTopView.addSubview(pokemonImage)
        
        nameLabel = UILabel()
        nameLabel.text = pokemonName
        nameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        newTopView.addSubview(nameLabel)
        
        movesTableView = UITableView()
        movesTableView.frame = CGRect(x: 0, y: newTopView.frame.height, width: view.frame.width, height: (view.frame.height) * 0.6)
//        movesTableView.backgroundColor = .black
        movesTableView.delegate = self
        movesTableView.dataSource = self
        movesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIden)
        view.addSubview(movesTableView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        activityIndicator.startAnimating()
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
                    pokemonImage.image = getImage(from: imageUrl)
                    self.activityIndicator.stopAnimating()


                }

            }
            catch {
                print(error)
            }


        }

        task.resume()

    }
    
    func getImage(from string: String) -> UIImage? {
        //2. Get valid URL
        guard let url = URL(string: string)
            else {
                print("Unable to create URL")
                return nil
        }
        
        var image: UIImage? = nil
        do {
            //3. Get valid data
            let data = try Data(contentsOf: url, options: [])
            
            //4. Make image
            image = UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return image
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

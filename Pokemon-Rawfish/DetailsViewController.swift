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

        view.backgroundColor = .white
        
       // MARK: - Declaring Views.
        
        let newTopView = UIView(frame: CGRect(x: 0, y: 0 , width: Int(view.frame.width), height: Int(view.frame.height) / 3 ))
        
        newTopView.backgroundColor = UIColor(white: 1, alpha: 0.2)
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
        pokemonImage.backgroundColor = UIColor(white: 0.7, alpha: 0.2)
        newTopView.addSubview(pokemonImage)
        
        nameLabel = UILabel()
        nameLabel.text = pokemonName.uppercased()
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.frame = CGRect(x: 0, y: (newTopView.frame.height) * 0.7, width: newTopView.frame.width, height: 100)
        newTopView.addSubview(nameLabel)
        
        movesTableView = UITableView()
        movesTableView.frame = CGRect(x: 0, y: newTopView.frame.height, width: view.frame.width, height: (view.frame.height) * 0.6)
        movesTableView.delegate = self
        movesTableView.dataSource = self
        movesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIden)
        movesTableView.backgroundColor = UIColor(white: 1, alpha: 0)
        view.addSubview(movesTableView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        activityIndicator.startAnimating()
        
        make(request: URL(string: url)!)

    }
    
    //MARK: - Handle Networking
    
    func make(request withURL: URL) {
        var request = URLRequest(url: withURL)
        request.httpMethod = "GET"
        send(request: request)
    }
    
    func handle(respone: (Data?, URLResponse?, Error?)) {
        guard let data = respone.0 else {return }
        do {
            (moves, imageUrl) = try process(data: data)
            updateUI()
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
    
    func process(data: Data) throws ->  ([Move], String) {
        let jsonData = try JSONDecoder().decode(PokemonDetails.self, from: data)
        return (jsonData.moves, (jsonData.sprites.other?.officialArtwork.frontDefault)!)
    }
    
    func updateUI() {
        activityIndicator.stopAnimating()
        pokemonImage.image = getImage(from: imageUrl)
        movesTableView.reloadData()
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
    
 // MARK: - Setting The TableView
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movesTableView.dequeueReusableCell(withIdentifier: cellReuseIden)
        cell!.textLabel?.text = moves[indexPath.row].move.name
        cell?.textLabel?.textColor = .black
        return cell!
        
    }
    
    
}

//
//  ViewController.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/11/21.
//

import UIKit

class HomeViewController: UIViewController {

    private var pokemonsTableView: UITableView!
    private var pokemonElement = [Result]()


    private var sortSwitch: UISwitch!
    private let refreshControl = UIRefreshControl()

    private var reuseIden = "Pokemon Identifier"





    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .white


        pokemonsTableView = UITableView()
        pokemonsTableView.translatesAutoresizingMaskIntoConstraints = false
        pokemonsTableView.dataSource = self
        pokemonsTableView.delegate = self
        pokemonsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIden)
        pokemonsTableView.backgroundColor = .white
        pokemonsTableView.separatorColor = .white
        view.addSubview(pokemonsTableView)

        pokemonsTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshPokemons(_:)), for: .valueChanged)


        sortSwitch = UISwitch()
        sortSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortSwitch)

        setupConstraints()
        getPokemons()

    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pokemonsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pokemonsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            pokemonsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)

        ])
        NSLayoutConstraint.activate([
            sortSwitch.leadingAnchor.constraint(equalTo: pokemonsTableView.leadingAnchor),
            sortSwitch.bottomAnchor.constraint(equalTo: pokemonsTableView.topAnchor)
        ])

    }


    func getPokemons(){

        let url = "https://pokeapi.co/api/v2/pokemon/"
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
                let jsonData = try JSONDecoder().decode(PokemonElements.self, from: data)
                self.pokemonElement = jsonData.results


                DispatchQueue.main.async {
                    self.pokemonsTableView.reloadData()
                }

            }
            catch {
                print(error)
            }


        }

        task.resume()
        refreshControl.endRefreshing()

    }

    @objc private func refreshPokemons(_ sender: Any) {
        getPokemons()
    }


}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonElement.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIden)

        if sortSwitch.isOn {
            sortSwitch.setOn(true, animated: true)
            cell.textLabel?.text = pokemonElement.sorted {
                $0.name < $1.name
            }[indexPath.row].name

        }
        
        else {
            sortSwitch.setOn(false, animated: true)
            cell.textLabel?.text = pokemonElement.sorted {
                $0.name > $1.name
            }[indexPath.row].name

        }


        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 5
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height) / 5
    }
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        

        pokemonsTableView.deselectRow(at: indexPath, animated: true)

        let detailsView = DetailsViewController()
        if sortSwitch.isOn {
            sortSwitch.setOn(true, animated: true)
            detailsView.url = pokemonElement.sorted {
                $0.name < $1.name
            }[indexPath.row].url
            
            detailsView.pokemonName = pokemonElement.sorted {
                $0.name < $1.name
            }[indexPath.row].name
            
            print(detailsView.url)

        }
        
        else {
            sortSwitch.setOn(false, animated: true)
            detailsView.url = pokemonElement.sorted {
                $0.name > $1.name
            }[indexPath.row].url
            
            detailsView.pokemonName = pokemonElement.sorted {
                $0.name > $1.name
            }[indexPath.row].name


        }
        
        present(detailsView, animated: true, completion: nil)


    }
}



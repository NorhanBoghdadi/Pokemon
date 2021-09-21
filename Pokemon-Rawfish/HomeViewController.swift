//
//  ViewController.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/11/21.
//

import UIKit

class HomeViewController: UIViewController, UISearchControllerDelegate {

    private var pokemonsTableView: UITableView!
    private var pokemonElement = [Result]()

    private var sortSwitch: UISwitch!
    private let refreshControl = UIRefreshControl()
    
    
    var searchController = UISearchController(searchResultsController: nil)

    private var reuseIden = "Pokemon Identifier"




    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .white
        title = "Change order"


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

        sortSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        sortSwitch.translatesAutoresizingMaskIntoConstraints = false
        sortSwitch.addTarget(self, action: #selector(switchISPressed), for: .valueChanged)
        sortSwitch.isEnabled = true
        view.addSubview(sortSwitch)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sortSwitch)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector (setupSearchBar))
        
        setupConstraints()
        getPokemons()

    }
    @objc func setupSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemons "
        navigationItem.titleView = searchController.searchBar
//        navigationItem.rightBarButtonItem = nil
        searchController.becomeFirstResponder()

    }
    
   
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pokemonsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pokemonsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pokemonsTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
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
                self.pokemonElement = self.sortArr(arr: jsonData.results)

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
    
    func sortArr(arr: [Result]) -> [Result] {
        return arr.sorted {
            $0.name < $1.name
        }
    }
    func reverseArr(arr: [Result]) -> [Result] {
        return arr.sorted {
            $0.name > $1.name
        }
    }

    @objc func switchISPressed(_ sender:UISwitch) {
        if (sender.isOn == true){
            sortSwitch.setOn(true, animated: true)
            pokemonElement = sortArr(arr: pokemonElement)
            pokemonsTableView.reloadData()
        }
        else {
            sortSwitch.setOn(true, animated: true)
            pokemonElement = reverseArr(arr: pokemonElement)
            pokemonsTableView.reloadData()
        }
        
    }
   
    

}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonElement.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = pokemonsTableView.dequeueReusableCell(withIdentifier: reuseIden)


        cell!.textLabel?.text = pokemonElement[indexPath.row].name
        cell!.layer.borderColor = UIColor.lightGray.cgColor
        cell!.layer.borderWidth = 5
        cell!.layer.cornerRadius = 10
        cell!.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
        cell!.textLabel?.textColor = .black
        return cell!

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
        detailsView.url = pokemonElement[indexPath.row].url
        
        present(detailsView, animated: true, completion: nil)


    }
}



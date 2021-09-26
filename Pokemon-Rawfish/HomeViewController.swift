//
//  ViewController.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/11/21.
//

import UIKit

class HomeViewController: UIViewController {

    let imageLoader = ImageLoader()
    let imgLink = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
    
    var loadedImg: UIImage?
    var cellImg: UIImage {
        loadedImg ?? UIImage(named: "2")!
    }
    
    private var pokemonsTableView: UITableView!
    private var pokemonElement = [PokemonResult]()
    
    private var sortSwitch: UIButton!
    private let refreshControl = UIRefreshControl()
    
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var isSortedZA = false
    private var reuseIden = "Pokemon Identifier"
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!



    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .white
       
        // MARK: - Declaring Views
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
        
        sortSwitch = UIButton(frame: .zero)
        sortSwitch.setImage(UIImage(named: "revSort"), for: .normal)
        sortSwitch.addTarget(self, action: #selector(switchISPressed), for: .touchUpInside)
        sortSwitch.isEnabled = true
        view.addSubview(sortSwitch)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sortSwitch)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector (setupSearchBar))
        
        
        setupConstraints()
        make(request: url)
        loadImage()

    }
    
    // MARK: - Setting SearchBar function
    @objc func setupSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemons "
        navigationItem.titleView = searchController.searchBar
        searchController.becomeFirstResponder()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true

    }
    //MARK: - Constraints
        
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pokemonsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pokemonsTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
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
            pokemonElement = try process(data: data)
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
    
    func process(data: Data) throws ->  [PokemonResult] {
        let jsonData = try JSONDecoder().decode(PokemonElements.self, from: data)
        return sortArr(arr: jsonData.results)
    }
    
    func updateUI() {
        refreshControl.endRefreshing()
        pokemonsTableView.reloadData()
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
                self.pokemonsTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
            
        }
    }
    
    

// MARK: - Additional Functions :
    @objc private func refreshPokemons(_ sender: Any) {
        make(request: url)
    }

    func sortArr(arr: [PokemonResult]) -> [PokemonResult] {
        return arr.sorted {
            $0.name < $1.name
        }
    }
    

    @objc func switchISPressed() {
        if(isSortedZA) {
            pokemonElement = sortArr(arr: pokemonElement)
            sortSwitch.setImage(UIImage(named: "revSort"), for: .normal)
            isSortedZA = false
            pokemonsTableView.reloadData()
        }
        else {
            sortSwitch.setImage(UIImage(named: "sort"), for: .normal)
            pokemonElement = pokemonElement.reversed()
            isSortedZA = true
            pokemonsTableView.reloadData()

        }
    
    }
    
    


}

// MARK: - Setting the tableView:

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pokemonElement.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = pokemonsTableView.dequeueReusableCell(withIdentifier: reuseIden)
        cell!.textLabel?.text = pokemonElement[indexPath.row].name.uppercased()
        cell!.layer.borderColor = UIColor(white: 0.7, alpha: 0.2).cgColor
        cell!.layer.borderWidth = 2
        cell!.layer.cornerRadius = 10
        cell!.backgroundColor = UIColor(white: 0.7, alpha: 0.2)
        cell!.textLabel?.textColor = .black
        
        cell?.imageView?.image = cellImg
        
        return cell!

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height) / 7
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")

        pokemonsTableView.deselectRow(at: indexPath, animated: true)
        let detailsView = DetailsViewController()
        detailsView.url = pokemonElement[indexPath.row].url
        detailsView.pokemonName = pokemonElement[indexPath.row].name
        
        present(detailsView, animated: true, completion: nil)
    }
}

//MARK: - Update searchResults:
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}



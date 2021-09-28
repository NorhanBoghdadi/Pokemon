//
//  ViewController.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/11/21.
//

import UIKit

class HomeViewController: UIViewController {

    let imageLoader = ImageLoader()
    
   
    
    private var pokemonsTableView: UITableView!
    
    private var sortSwitch: UIButton!
    private let refreshControl = UIRefreshControl()
    
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var isSortedZA = false
    private var reuseIden = "Pokemon Identifier"
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!

// MARK: - ModelView transformation
    
    var viewModel: ViewModel?
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .white
        
        viewModel = HomeViewModel(viewController: self)
       
        // MARK: - Declaring Views
        pokemonsTableView = UITableView()
        pokemonsTableView.translatesAutoresizingMaskIntoConstraints = false
        pokemonsTableView.dataSource = self
        pokemonsTableView.delegate = self
        pokemonsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIden)
//        pokemonsTableView.backgroundColor = .white
//        pokemonsTableView.separatorColor = .white
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
    
      
    

// MARK: - Additional Functions :
    @objc private func refreshPokemons(_ sender: Any) {
        dataLoaded()
    }
    

    @objc func switchISPressed() {
        if(isSortedZA) {
//            pokemonElement = sortArr(arr: pokemonElement)
            sortSwitch.setImage(UIImage(named: "revSort"), for: .normal)
            isSortedZA = false
            pokemonsTableView!.reloadData()
        }
        else {
            sortSwitch.setImage(UIImage(named: "sort"), for: .normal)
//            pokemonElement = pokemonElement.reversed()
            isSortedZA = true
            pokemonsTableView!.reloadData()

        }
    
    }
    
    


}

// MARK: - Setting the tableView:

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel!.numberOfPokemons
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = pokemonsTableView.dequeueReusableCell(withIdentifier: reuseIden)
//        cell!.textLabel?.text = pokemonElement[indexPath.row].name.uppercased()
        cell!.layer.borderColor = UIColor(white: 0.7, alpha: 0.2).cgColor
        cell!.layer.borderWidth = 2
        cell!.layer.cornerRadius = 10
        cell!.backgroundColor = UIColor(white: 0.7, alpha: 0.2)
        cell!.textLabel?.textColor = .black
//
//        cell?.imageView?.image = cellImg
        let data = viewModel?.data(for: indexPath)
        cell?.textLabel?.text = data?.name.uppercased()
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
        let data = viewModel?.data(for: indexPath)
        detailsView.url = data!.url
        detailsView.pokemonName = data!.name

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


extension HomeViewController: NotifaiableController {
    func dataLoaded() {
        pokemonsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
}
extension HomeViewController: LoadableController {
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    
    
}

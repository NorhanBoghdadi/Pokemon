//
//  ViewController.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/11/21.
//

import UIKit

class ViewController: UIViewController {

    var pokemonsTableView: UITableView!
    var pokemonElements = [PokemonElements]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .black
        
        
        pokemonsTableView = UITableView()
        pokemonsTableView.translatesAutoresizingMaskIntoConstraints = false
//        pokemonsTableView.dataSource = self
//        pokemonsTableView.delegate = self
//        pokemonsTableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
        pokemonsTableView.backgroundColor = .white
        
        pokemonsTableView.reloadData()
        
        view.addSubview(pokemonsTableView)
        
        setupConstraints()
        
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pokemonsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pokemonsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            pokemonsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        
        ])
        
    }


}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
extension ViewController: UITableViewDelegate {
    
}


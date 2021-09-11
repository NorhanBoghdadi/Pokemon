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
    
    var reuseIden = "Pokemon Identifier"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .black
        
        
        pokemonsTableView = UITableView()
        pokemonsTableView.translatesAutoresizingMaskIntoConstraints = false
        pokemonsTableView.dataSource = self
        pokemonsTableView.delegate = self
        pokemonsTableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: reuseIden)
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
        let cell = PokemonTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIden)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height) / 5
    }
}
extension ViewController: UITableViewDelegate {
    
}


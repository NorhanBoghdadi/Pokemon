//
//  PokemonTableViewCell.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/11/21.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    var pokemonName: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        pokemonName = UILabel()
        pokemonName.translatesAutoresizingMaskIntoConstraints = false
        pokemonName.font = UIFont.systemFont(ofSize: 20)
        pokemonName.textColor = .orange
        
    
        contentView.addSubview(pokemonName)
        contentView.backgroundColor = .black
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            pokemonName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        
        ])
    }
    func configure(for pokemonElement: Result){
        
        pokemonName.text = pokemonElement.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//
//  ViewModelProtocols.swift
//  Pokemon-Rawfish
//
//  Created by Norhan Boghdadi on 9/27/21.
//

import Foundation

typealias DataLoaderController = (LoadableController & NotifaiableController)?

protocol ViewModel: ReusableDataViewModel {
    var viewController: DataLoaderController? { get }
    var numberOfPokemons: Int { get }
    
}

protocol ReusableDataViewModel {
    func data(for cellAt: IndexPath) -> PokemonResult
}

protocol LoadableController: AnyObject {
    func showLoader()
    func hideLoader()
}

protocol NotifaiableController: AnyObject {
    func dataLoaded()
}

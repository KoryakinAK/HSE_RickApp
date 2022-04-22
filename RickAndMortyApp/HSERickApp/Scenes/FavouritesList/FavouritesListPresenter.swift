// 
//  FavouritesListPresenter.swift
//  HSERickApp
//
//  Created by Alexey Koryakin on 22.04.2022.
//

import Foundation

protocol FavouritesListPresenterProtocol: AnyObject {
    init(view: FavouritesListVCProtocol, router: FavouritesListRouter)
    
    func didSelect(row: Int)
    func retrieveFavCharacters()
    
    var favCharactersList: [CharacterModel] { get set }
}

final class FavouritesListPresenter: FavouritesListPresenterProtocol {
    
    private weak var view: FavouritesListVCProtocol?
    private var router: FavouritesListRouter
    
    var favCharactersList = [CharacterModel]() {
        didSet {
            print("lol")
        }
    }

    init(view: FavouritesListVCProtocol, router: FavouritesListRouter) {
        self.view = view
        self.router = router
    }
    
    func retrieveFavCharacters() {
        favCharactersList.append(CharacterModel(name: "Rick", imageURL: "-"))
        favCharactersList.append(CharacterModel(name: "Pick", imageURL: "-"))
        favCharactersList.append(CharacterModel(name: "Mick", imageURL: "-"))
        updateTableView()
    }
    
    func updateTableView() {
        view?.chararactersTableView.reloadData()
    }
    
    // MARK: - UITableView actions
    func didSelect(row: Int) {
        router.presentCharacterPage(for: favCharactersList[row])
    }
}

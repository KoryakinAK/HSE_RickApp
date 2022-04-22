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
}

final class FavouritesListPresenter: FavouritesListPresenterProtocol {
    
    private weak var view: FavouritesListVCProtocol?
    private var router: FavouritesListRouter

    init(view: FavouritesListVCProtocol, router: FavouritesListRouter) {
        self.view = view
        self.router = router
    }
    
    // MARK: - UITableView actions
    func didSelect(row at: Int) {
        // let character = персонажа из датасорса
        let character = CharacterModel(name: "Ricky Picky", imageURL: "-")
        router.presentCharacterPage(for: character)
    }
}

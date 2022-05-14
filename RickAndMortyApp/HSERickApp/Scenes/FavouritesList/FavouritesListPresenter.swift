import Foundation

protocol FavouritesListPresenterProtocol: AnyObject {
    init(view: FavouritesListVCProtocol, router: FavouritesListRouter, storageManager: StorageProtocol)

    func didSelect(row: Int)
    func retrieveFavCharacters()

    var favCharactersList: [CharacterModel] { get set }
}

final class FavouritesListPresenter: FavouritesListPresenterProtocol {
    private weak var view: FavouritesListVCProtocol?
    private var router: FavouritesListRouter
    private var storageManager: StorageProtocol
    var favCharactersList = [CharacterModel]()

    init(view: FavouritesListVCProtocol, router: FavouritesListRouter, storageManager: StorageProtocol) {
        self.view = view
        self.router = router
        self.storageManager = storageManager
    }

    func retrieveFavCharacters() {
        let currentFavs = storageManager.getCharactersIn(category: .favourites)
        currentFavs.forEach {
            self.favCharactersList.append($0)
            self.view?.chararactersTableView.reloadData()
        }
    }

    // MARK: - UITableView actions
    func didSelect(row: Int) {
        router.presentCharacterPage(for: favCharactersList[row])
    }
}

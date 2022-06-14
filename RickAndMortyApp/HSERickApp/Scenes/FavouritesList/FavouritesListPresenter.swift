import Foundation

protocol FavouritesListPresenterProtocol: AnyObject {
    init(view: FavouritesListVCProtocol, router: FavouritesListRouter, storageManager: StorageProtocol)

    func didSelect(row: Int)
    func updateFavCharacters()

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
        setupObservers()
        updateFavCharacters()
    }

    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFavCharacters), name: Notification.Name(UserDefaultsManager.notificationIdentifier), object: nil)
    }

    @objc func updateFavCharacters() {
        let currentFavs = storageManager.getAllElementsIn(category: .favourites)
        self.favCharactersList = currentFavs
        self.view?.chararactersTableView.reloadData()
        view?.emptyLabel.isHidden = !currentFavs.isEmpty
    }

    // MARK: - UITableView actions
    func didSelect(row: Int) {
        router.presentCharacterPage(for: favCharactersList[row])
    }
}

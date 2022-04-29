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
    
    var favCharactersList = [CharacterModel]()

    init(view: FavouritesListVCProtocol, router: FavouritesListRouter) {
        self.view = view
        self.router = router
    }
    
    func retrieveFavCharacters() {
        let currentFavs = UserDefaultsManager.sharedInstance().getCharacterIDsIn(category: .favourites)
        APIWorker.request(endpoint: RickAPIConfig.getMultipleCharacters(ids: currentFavs)) { (result: Result<[CharacterModel], Error>)  in
            switch result {
            case .success(let response):
                response.forEach {
                    self.favCharactersList.append($0)
                }
                self.view?.chararactersTableView.reloadData()
            case .failure(let _):
                print("Character info download failed")
            }
        }
    }
    
    // MARK: - UITableView actions
    func didSelect(row: Int) {
        router.presentCharacterPage(for: favCharactersList[row])
    }
}

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchVСProtocol, router: SearchRouter, storageManager: StorageProtocol)

    var searchResultCharacters: [CharacterModel] { get }
    var isSearchInProgress: Bool { get set }

    func didSelectSearchResultAt(row: Int, in category: CharacterCategory?)
    func askToSearchWith(name: String)

    func getNumberOfRows(in category: CharacterCategory) -> Int
    func getNumberOfSuggestedSections() -> Int
    func getCharacterFor(row: Int, in category: CharacterCategory) -> CharacterModel?
    func getSectionName(for section: Int) -> String
    func flipFavouriteStatus()
}

final class SearchPresenter: SearchPresenterProtocol {
    private weak var view: SearchVСProtocol?
    private var router: SearchRouter
    private var storageManager: StorageProtocol
    private var timer: Timer?
    private var nameToSearch: String?

    var searchResultMetaInfo: SearchMetaInfo?
    var searchResultCharacters = [CharacterModel]()
    var isSearchInProgress = false {
        didSet {
            self.view?.suggestionsTableView.reloadData()
        }
    }
    init(view: SearchVСProtocol, router: SearchRouter, storageManager: StorageProtocol) {
        self.view = view
        self.router = router
        self.storageManager = storageManager
    }

    // MARK: - Routing
    func didSelectSearchResultAt(row: Int, in category: CharacterCategory?) {
        if self.isSearchInProgress {
            router.presentCharacterPage(for: searchResultCharacters[row])
        } else {
            guard let category = category else { return }
            let charsInCategory = storageManager.getCharactersIn(category: category)
            router.presentCharacterPage(for: charsInCategory[row])
        }
    }

    // MARK: - Search handling
    func askToSearchWith(name: String) {
        // Возможно, стоит переписать на workItem
        timer?.invalidate()
        self.nameToSearch = name
    
        timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)

    }

    @objc private func performSearch() {
        guard
            let name = nameToSearch,
            name.count > 0
        else { return }

        APIWorker.request(
            endpoint: RickAPIEndpoint.searchBy(name: name)
        ) { (result: Result<SearchResultModel, Error>)  in
            switch result {
            case .success(let response):
                self.searchResultCharacters = response.results
                self.searchResultMetaInfo = response.info
                self.view?.suggestionsTableView.reloadData()
            case .failure(let error):
                self.clearSearchResults()
            }
        }
    }

    private func clearSearchResults() {
        // TODO: - Лейбл "Нет результатов"
        self.searchResultCharacters = [CharacterModel]()
        self.searchResultMetaInfo = nil
        view?.suggestionsTableView.reloadData()
    }

    func flipFavouriteStatus() {
//        if self.isCurrentCharFavourited {
//            self.storageManager.attemptToRemove(character: self.selectedCharacter, from: .favourites)
//        } else {
//            self.storageManager.save(character: self.selectedCharacter, to: .favourites)
//        }
    }

    // MARK: - UITableView helpers
    func getCharacterFor(row: Int, in category: CharacterCategory) -> CharacterModel? {
        let characters = storageManager.getCharactersIn(category: category)
        return characters[row]
    }

    func getNumberOfRows(in category: CharacterCategory) -> Int {
        return storageManager.getCharactersIn(category: category).count
    }

    func getNumberOfSuggestedSections() -> Int {
        return CharacterCategory.allCases.count
    }

    func getSectionName(for section: Int) -> String {
        return CharacterCategory.allCases[section].rawValue
    }

}

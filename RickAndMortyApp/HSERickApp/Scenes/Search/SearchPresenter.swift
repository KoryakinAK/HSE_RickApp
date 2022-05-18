import Foundation

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewControllerProtocol, router: SearchRouter, storageManager: StorageProtocol)

    func didSelectSearchResult(at row: Int)

    func performSearchWith(name: String)
    func getCharactersArray(with IDs: [UInt]) -> [CharacterModel]
    func getNumberOfRows(in category: CharacterCategory) -> Int
    func getNumberOfSuggestedSections() -> Int
    func getCharacterFor(row: Int, in category: CharacterCategory) -> CharacterModel?
    func getSectionName(for section: Int) -> String

    var searchResultCharacters: [CharacterModel] { get }
}

final class SearchPresenter: SearchPresenterProtocol {
    private weak var view: SearchViewControllerProtocol?
    private var router: SearchRouter
    private var storageManager: StorageProtocol

    var searchResultMetaInfo: SearchMetaInfo?
    var searchResultCharacters = [CharacterModel]()

    init(view: SearchViewControllerProtocol, router: SearchRouter, storageManager: StorageProtocol) {
        self.view = view
        self.router = router
        self.storageManager = storageManager
    }

    // MARK: - Routing
    func didSelectSearchResult(at row: Int) {
        router.presentCharacterPage(for: searchResultCharacters[row])
    }

    // MARK: - Search handling
    func performSearchWith(name: String) {
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
                print("Download failed: \(error.localizedDescription)")
            }
        }
    }

    func clearSearchResults() {
        self.searchResultCharacters = [CharacterModel]()
        self.searchResultMetaInfo = nil
        view?.suggestionsTableView.reloadData()
    }

    func getCharactersArray(with IDs: [UInt]) -> [CharacterModel] {
        var resultingArray = [CharacterModel]()
        APIWorker.request(
            endpoint: RickAPIEndpoint.getMultipleCharacters(ids: IDs)
        ) { (result: Result<[CharacterModel], Error>)  in
            switch result {
            case .success(let response):
                resultingArray = response
            case .failure(let error):
                print("Download failed: \(error.localizedDescription)")
            }
        }
        return resultingArray
    }

    func getCharacterFor(row: Int, in category: CharacterCategory) -> CharacterModel? {
        let characters = storageManager.getCharactersIn(category: category)
        return characters[row]
    }

    // MARK: - UITableView helpers
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

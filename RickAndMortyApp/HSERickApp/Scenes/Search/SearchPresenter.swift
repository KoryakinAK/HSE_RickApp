import Foundation

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewControllerProtocol, storageManager: StorageProtocol)
    func performSearchWith(name: String)
    func getCharactersArray(with IDs: [UInt]) -> [CharacterModel]
    func getNumberOfRows(in category: CharacterCategory) -> Int
    func getNumberOfSections() -> Int
    func getCharacterFor(row: Int, in category: CharacterCategory) -> CharacterModel?

    var searchResultCharacters: [CharacterModel] { get }
}

final class SearchPresenter: SearchPresenterProtocol {
    private weak var view: SearchViewControllerProtocol?
    private var storageManager: StorageProtocol

    var dataSource = [[CharacterModel]]()
    var searchResultMetaInfo: SearchMetaInfo?
    var searchResultCharacters = [CharacterModel]()

    init(view: SearchViewControllerProtocol, storageManager: StorageProtocol) {
        self.view = view
        self.storageManager = storageManager
    }

    // MARK: - Networking
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
                print("Download failed: \(error.localizedDescription)")
            }
        }
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

    func getNumberOfSections() -> Int {
        return CharacterCategory.allCases.count
    }

}

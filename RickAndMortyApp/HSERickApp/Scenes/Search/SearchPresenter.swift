import Foundation

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewControllerProtocol, storageManager: StorageProtocol)
    func getCharactersArray(with IDs: [UInt]) -> [CharacterModel]
    func getNumberOfRows(in category: CharacterCategory) -> Int
    func getNumberOfSections() -> Int
    func getCharacterFor(row: Int, in category: CharacterCategory) -> CharacterModel?
}

final class SearchPresenter: SearchPresenterProtocol {
    private weak var view: SearchViewControllerProtocol?
    private var storageManager: StorageProtocol

    var dataSource = [[CharacterModel]]()

    init(view: SearchViewControllerProtocol, storageManager: StorageProtocol) {
        self.view = view
        self.storageManager = storageManager
    }

    // MARK: - Networking
    func getCharactersArray(with IDs: [UInt]) -> [CharacterModel] {
        var resultingArray = [CharacterModel]()
        APIWorker.request(
            endpoint: RickAPIConfig.getMultipleCharacters(ids: IDs)
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

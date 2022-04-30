import Foundation

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewControllerProtocol)
    func getCharactersArray(with IDs: [UInt]) -> [CharacterModel]
    func getNumberOfRows(in section: Int) -> Int
    func getNumberOfSections() -> Int
}

final class SearchPresenter: SearchPresenterProtocol {
    
    private weak var view: SearchViewControllerProtocol?
    
    var dataSource = [[CharacterModel]]()
    
    init(view: SearchViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Networking
    func getCharactersArray(with IDs: [UInt]) -> [CharacterModel] {
        var resultingArray = [CharacterModel]()
        APIWorker.request(endpoint: RickAPIConfig.getMultipleCharacters(ids: IDs)) { (result: Result<[CharacterModel], Error>)  in
            switch result {
            case .success(let response):
                resultingArray = response
            case .failure(let error):
                print("Download failed: \(error.localizedDescription)")
            }
        }
        return resultingArray
    }
    
    // MARK: - UITableView helpers
    func getNumberOfRows(in section: Int) -> Int {
        let caterogy = UserDefaultsManager.DataCategory.allCases[section]
        return UserDefaultsManager.sharedInstance().getCharacterIDsIn(category: caterogy).count
    }
    
    func getNumberOfSections() -> Int {
        return UserDefaultsManager.DataCategory.allCases.count
    }

}

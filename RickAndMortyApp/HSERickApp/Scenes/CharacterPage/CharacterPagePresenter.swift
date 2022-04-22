import Foundation

protocol CharacterPagePresenterProtocol: AnyObject {
    init(view: CharacterPageViewControllerProtocol)
    var currentCharacterInfo: [CharacterDescriptionModel]? { get }
    func retrieveCharacterInformation()
}

final class CharacterPagePresenter: CharacterPagePresenterProtocol {
    
    private weak var view: CharacterPageViewControllerProtocol?
    var currentCharacterInfo: [CharacterDescriptionModel]?
    
    init(view: CharacterPageViewControllerProtocol) {
        self.view = view
    }
    
    func retrieveCharacterInformation() {
        self.currentCharacterInfo = [
            CharacterDescriptionModel(characteristic: "Status:", value: "Alive"),
            CharacterDescriptionModel(characteristic: "Species:", value: "Human"),
            CharacterDescriptionModel(characteristic: "Gender:", value: "Male")
        ]
        updateTableView()
    }
    
    func updateTableView() {
        view?.characterInfoTableView.reloadData()
    }
}

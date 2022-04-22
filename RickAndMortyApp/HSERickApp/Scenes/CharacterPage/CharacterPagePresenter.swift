import Foundation

protocol CharacterPagePresenterProtocol: AnyObject {
    init(view: CharacterPageViewControllerProtocol)
    var characterInfo: [CharacterDescriptionModel]? { get }
    func retrieveCharacterInformation()
}

final class CharacterPagePresenter: CharacterPagePresenterProtocol {
    
    private weak var view: CharacterPageViewControllerProtocol?
    var characterInfo: [CharacterDescriptionModel]?
    
    init(view: CharacterPageViewControllerProtocol) {
        self.view = view
    }
    
    func retrieveCharacterInformation() {
        self.characterInfo = [
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

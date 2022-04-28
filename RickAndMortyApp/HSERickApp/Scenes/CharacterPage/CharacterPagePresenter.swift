import Foundation

protocol CharacterPagePresenterProtocol: AnyObject {
    init(view: CharacterPageViewControllerProtocol)
    var currentCharacterInfo: [CharacterDescriptionModel] { get }
    func setCharacterInformation(with: CharacterModel)
}

final class CharacterPagePresenter: CharacterPagePresenterProtocol {
    
    private weak var view: CharacterPageViewControllerProtocol?
    var currentCharacterInfo = [CharacterDescriptionModel]()
    
    init(view: CharacterPageViewControllerProtocol) {
        self.view = view
    }
    
    func setCharacterInformation(with character: CharacterModel) {
        for (characteristic, value) in character.AsDictOfDescriptions() {
            self.currentCharacterInfo.append(CharacterDescriptionModel(characteristic: characteristic, value: value))
        }
        view?.characterInfoTableView.reloadData()
    }
    
    func updateTableView() {
        view?.characterInfoTableView.reloadData()
    }
}

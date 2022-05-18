import Foundation
import UIKit

protocol CharacterPagePresenterProtocol: AnyObject {
    init(view: CharacterPageViewControllerProtocol, storageManager: StorageProtocol, selectedCharacter: CharacterModel)
    var currentCharacterInfo: [CharacterDescriptionModel] { get }
    var isCurrentCharFavourited: Bool { get }
    var selectedCharacter: CharacterModel { get }
    func flipFavouriteStatus()
    func presentCurrentCharacter()
}

final class CharacterPagePresenter: CharacterPagePresenterProtocol {
    var isCurrentCharFavourited: Bool {
        self.storageManager.getCharactersIn(category: .favourites).contains(self.selectedCharacter)
    }

    private weak var view: CharacterPageViewControllerProtocol?
    private var storageManager: StorageProtocol
    var currentCharacterInfo = [CharacterDescriptionModel]()
    var selectedCharacter: CharacterModel

    init(view: CharacterPageViewControllerProtocol, storageManager: StorageProtocol, selectedCharacter: CharacterModel) {
        self.view = view
        self.storageManager = storageManager
        self.selectedCharacter = selectedCharacter
        self.storageManager.save(character: self.selectedCharacter, to: .recent)
        performInitialSetup()
    }

    func performInitialSetup() {
        for (characteristic, value) in self.selectedCharacter.asDictOfDescriptions() {
            self.currentCharacterInfo.append(CharacterDescriptionModel(characteristic: characteristic, value: value))
        }
        self.updateTableView()
    }

    func flipFavouriteStatus() {
        if self.isCurrentCharFavourited {
            self.storageManager.attemptToRemove(character: self.selectedCharacter, from: .favourites)
        } else {
            self.storageManager.save(character: self.selectedCharacter, to: .favourites)
        }
    }

    func presentCurrentCharacter() {
        view?.setupCharacterNameAndIcon(for: self.selectedCharacter)
    }

    func updateTableView() {
        view?.characterInfoTableView.reloadData()
    }

    func checkIfInFavourites(character: CharacterModel) -> Bool {
        return self.storageManager.getCharactersIn(category: .favourites).contains(character)
    }
}

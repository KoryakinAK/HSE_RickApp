import UIKit

final class CharacterPageBuilder {
    public static func build(for character: CharacterModel) -> CharacterPageViewController {
        let view = CharacterPageViewController()
//        view.setupCharacterNameAndIcon(for: character)
        let storageManager = UserDefaultsManager.sharedInstance()
        let presenter = CharacterPagePresenter(view: view, storageManager: storageManager, selectedCharacter: character)
        view.presenter = presenter
        return view
    }
}

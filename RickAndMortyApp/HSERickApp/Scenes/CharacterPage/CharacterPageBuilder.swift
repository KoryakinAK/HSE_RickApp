import UIKit

final class CharacterPageBuilder {
    public static func build(for character: CharacterModel) -> CharacterPageViewController {
        let view = CharacterPageViewController()
        view.setupCharacterNameAndIcon(for: character)
        let presenter = CharacterPagePresenter(view: view)
        view.presenter = presenter
        presenter.setCharacterInformation(with: character)
        return view
    }
}

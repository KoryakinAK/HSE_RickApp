import Foundation

protocol SearchRouterProtocol {
    init(view: SearchViewController)
}

final class SearchRouter: SearchRouterProtocol {

    private weak var view: SearchViewController?

    init(view: SearchViewController) {
        self.view = view
    }

    func presentCharacterPage(for character: CharacterModel) {
        self.view?.present(CharacterPageBuilder.build(for: character), animated: true)
    }
}

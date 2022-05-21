import Foundation

protocol SearchRouterProtocol {
    init(view: SearchVС)
}

final class SearchRouter: SearchRouterProtocol {

    private weak var view: SearchVС?

    init(view: SearchVС) {
        self.view = view
    }

    func presentCharacterPage(for character: CharacterModel) {
        self.view?.present(CharacterPageBuilder.build(for: character), animated: true)
    }
}

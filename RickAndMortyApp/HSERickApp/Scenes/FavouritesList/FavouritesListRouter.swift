import Foundation

protocol FavouritesListRouterProtocol {
    init(view: FavouritesListVC)
}

final class FavouritesListRouter: FavouritesListRouterProtocol {

    private weak var view: FavouritesListVC?

    init(view: FavouritesListVC) {
        self.view = view
    }

    func presentCharacterPage(for character: CharacterModel) {
        self.view?.navigationController?.pushViewController(CharacterPageBuilder.build(for: character), animated: true)
    }
}

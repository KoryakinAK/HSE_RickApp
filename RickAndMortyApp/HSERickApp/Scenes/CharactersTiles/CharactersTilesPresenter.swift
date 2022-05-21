import Foundation

protocol CharactersTilesPresenterProtocol: AnyObject {
    init(view: CharactersTilesViewControllerProtocol, router: CharactersTilesRouterProtocol)
}

final class CharactersTilesPresenter: CharactersTilesPresenterProtocol {
    private weak var view: CharactersTilesViewControllerProtocol?
    private var router: CharactersTilesRouterProtocol

    init(view: CharactersTilesViewControllerProtocol, router: CharactersTilesRouterProtocol) {
        self.view = view
        self.router = router
    }
}

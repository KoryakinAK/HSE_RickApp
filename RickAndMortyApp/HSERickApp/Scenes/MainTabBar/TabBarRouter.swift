import Foundation

protocol TabBarRouterProtocol {
    init(view: TabBarViewController)
    func presentSearchScreen()
}

final class TabBarRouter: TabBarRouterProtocol {
    private weak var view: TabBarViewController?

    init(view: TabBarViewController) {
        self.view = view
    }

    func presentSearchScreen() {
        self.view?.navigationController?.pushViewController(SearchBuilder.build(), animated: true)
    }
}

import UIKit

protocol TabBarPresenterProtocol: AnyObject {
    init(view: TabBarViewControllerProtocol, router: TabBarRouter)
    var lastSelectedTab: Int { get set }
}

final class TabBarPresenter: TabBarPresenterProtocol {
    private weak var view: TabBarViewControllerProtocol?
    private var router: TabBarRouter

    var lastSelectedTab: Int = 0

    init(view: TabBarViewControllerProtocol, router: TabBarRouter) {
        self.view = view
        self.router = router
    }
}

import Foundation

protocol HomePresenterProtocol: AnyObject {
    init(view: HomeVCProtocol)
}

final class HomePresenter: HomePresenterProtocol {
    private weak var view: HomeVCProtocol?

    init(view: HomeVCProtocol) {
        self.view = view
    }
}

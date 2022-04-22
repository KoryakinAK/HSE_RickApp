import Foundation

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewControllerProtocol)
}

final class SearchPresenter: SearchPresenterProtocol {
    
    private weak var view: SearchViewControllerProtocol?
    
    init(view: SearchViewControllerProtocol) {
        self.view = view
    }
}

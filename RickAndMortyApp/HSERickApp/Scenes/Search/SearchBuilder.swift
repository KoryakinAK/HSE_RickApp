import UIKit

final class SearchBuilder {
    public static func build() -> SearchViewController {
        let view = SearchViewController()
        let storageManager = UserDefaultsManager.sharedInstance()
        let presenter = SearchPresenter(view: view, storageManager: storageManager)
        view.presenter = presenter
        return view
    }
}

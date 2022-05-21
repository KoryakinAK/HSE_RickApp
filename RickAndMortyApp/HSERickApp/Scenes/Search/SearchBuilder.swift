import UIKit

final class SearchBuilder {
    public static func build() -> SearchVС {
        let view = SearchVС()
        let storageManager = UserDefaultsManager.sharedInstance()
        let router = SearchRouter(view: view)
        let presenter = SearchPresenter(view: view, router: router, storageManager: storageManager)
        view.presenter = presenter
        return view
    }
}

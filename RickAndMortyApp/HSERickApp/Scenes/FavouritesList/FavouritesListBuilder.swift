import UIKit

final class FavouritesListBuilder {

    public static func build() -> FavouritesListVC {
        let view = FavouritesListVC()
        let router = FavouritesListRouter(view: view)
        let storageManager = UserDefaultsManager.sharedInstance()
        let presenter = FavouritesListPresenter(view: view, router: router, storageManager: storageManager)
        view.presenter = presenter
        return view
    }
}

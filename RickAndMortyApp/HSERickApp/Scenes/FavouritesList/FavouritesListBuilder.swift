import UIKit

final class FavouritesListBuilder {
    
    public static func build() -> FavouritesListVC {
        let view = FavouritesListVC()
        let router = FavouritesListRouter(view: view)
        let presenter = FavouritesListPresenter(view: view, router: router)
        
        view.presenter = presenter
        
        return view
    }
    
}

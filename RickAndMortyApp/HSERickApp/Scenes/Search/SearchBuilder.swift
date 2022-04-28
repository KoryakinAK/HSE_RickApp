import UIKit

final class SearchBuilder {
    
    public static func build() -> SearchViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter(view: view)
        
        view.presenter = presenter
        
        return view
    }
    
}

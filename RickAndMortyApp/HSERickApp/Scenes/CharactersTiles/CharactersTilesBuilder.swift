import UIKit

final class CharactersTilesBuilder {

    public static func build() -> CharactersTilesVC {
        let view = CharactersTilesVC()
        let router = CharactersTilesRouter(view: view)
        let presenter = CharactersTilesPresenter(view: view, router: router)
        view.presenter = presenter

        return view
    }
}

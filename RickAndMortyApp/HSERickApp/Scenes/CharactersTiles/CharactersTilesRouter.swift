import UIKit

protocol CharactersTilesRouterProtocol {
    init(view: CharactersTilesVC)
}

final class CharactersTilesRouter: CharactersTilesRouterProtocol {
    private weak var view: CharactersTilesVC?

    init(view: CharactersTilesVC) {
        self.view = view
    }
}

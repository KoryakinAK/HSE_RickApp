import Foundation
import SwiftUI

protocol FavouritesListRouterProtocol {
    init(view: FavouritesListVC)
}

final class FavouritesListRouter: FavouritesListRouterProtocol {

    private weak var view: FavouritesListVC?

    init(view: FavouritesListVC) {
        self.view = view
    }

    func presentCharacterPage(for character: CharacterModel) {
        // Сейчас при открытии персонажа открывается случайно либо UIKit, либо SwiftUI
        // Когда будет доделана корректная связка SwiftUI с презентером, UIKit будет удален
        // Сейчас SwiftUI только отображает, но не возвращает действия назад
        if Bool.random() {
            self.view?.navigationController?.pushViewController(CharacterPageBuilder.buildWithSwiftUI(for: character), animated: true)
        } else {
            self.view?.navigationController?.pushViewController(CharacterPageBuilder.build(for: character), animated: true)
        }
    }
}

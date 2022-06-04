import UIKit
import SwiftUI

final class CharacterPageBuilder {
    public static func build(for character: CharacterModel) -> CharacterPageViewController {
        let view = CharacterPageViewController()
        let storageManager = UserDefaultsManager.sharedInstance()
        let presenter = CharacterPagePresenter(view: view, storageManager: storageManager, selectedCharacter: character)
        view.presenter = presenter
        return view
    }

    public static func buildWithSwiftUI(for character: CharacterModel) -> UIViewController {
        let characterUIInfo = CharacterUIInfo(with: character)
        let UIView = CharacterPageUI()
        let view = UIHostingController(rootView: UIView.environmentObject(characterUIInfo))
        view.navigationController?.setNavigationBarHidden(true, animated: false)
        view.navigationItem.largeTitleDisplayMode = .never
        return view
    }
}

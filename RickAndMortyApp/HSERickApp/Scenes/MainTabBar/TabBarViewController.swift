import UIKit

protocol TabBarViewControllerProtocol: AnyObject {

}

final class TabBarViewController: UITabBarController, TabBarViewControllerProtocol {
    public var presenter: TabBarPresenterProtocol!

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupVC()
    }

    private func setupAppearance() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        tabBar.tintColor = UIColor(named: "mainLabelColor")
        tabBar.barTintColor = UIColor(named: "backgroundColor")
        tabBar.backgroundColor =  UIColor(named: "backgroundColor")
    }

    private func setupVC() {
        let selectedImageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .medium)
        viewControllers = [
            self.presenter.createNavController(for: HomeBuilder.build(),
                                          title: "",
                                          image: UIImage(systemName: "house")!,
                                          withVisibleTitle: false,
                                          withSelectedImage: nil),

            self.presenter.createNavController(for: FavouritesListBuilder.build(),
                                          title: "Favourites",
                                          image: UIImage(systemName: "heart")!,
                                          withVisibleTitle: true,
                                          withSelectedImage: UIImage(systemName: "heart.circle.fill",
                                                                     withConfiguration: selectedImageConfig)),

            self.presenter.createNavController(for: UIViewController(),
                                          title: "",
                                          image: UIImage(systemName: "magnifyingglass")!,
                                          withVisibleTitle: false,
                                          withSelectedImage: nil)
        ]
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            tabBarController.selectedIndex = presenter.lastSelectedTab
            self.present(SearchBuilder.build(), animated: true)
        } else {
            presenter.lastSelectedTab = tabBarController.selectedIndex
        }
    }
}

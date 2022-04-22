import UIKit

class TabBar: UITabBarController {
    var lastSelectedTab: Int = 0

    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage,
                                         withVisibleTitle titleVisible: Bool = false,
                                         withSelectedImage selectedImage: UIImage? = nil
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image

        navController.tabBarItem.selectedImage = selectedImage
        if titleVisible {
            navController.navigationBar.prefersLargeTitles = true
            rootViewController.navigationItem.title = title
        }
        return navController
    }
    
// MARK: - VC Setup
    func setupVC() {
        let selectedImageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .medium)
        
        viewControllers = [
            createNavController(for: HomeBuilder.build(),
                                title: "",
                                image: UIImage(systemName: "house")!),

            createNavController(for: FavouritesListBuilder.build(),
                                title: "Favourites",
                                image: UIImage(systemName: "heart")!,
                                withVisibleTitle: true,
                                withSelectedImage: UIImage(systemName: "heart.circle.fill",
                                                           withConfiguration: selectedImageConfig)),
    
            createNavController(for: UIViewController(),
                                title: "",
                                image: UIImage(systemName: "magnifyingglass")!)
        ]
    }
    
// MARK: - VC Lifecycle
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        let apperearance = UINavigationBarAppearance()
        apperearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = apperearance
        self.navigationItem.scrollEdgeAppearance = apperearance
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        tabBar.tintColor = UIColor(named: "mainLabelColor")
        tabBar.barTintColor = UIColor(named: "backgroundColor")
        setupVC()
    }
}

// MARK: - UITabBar Delegate Extension
extension TabBar: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            tabBarController.selectedIndex = self.lastSelectedTab
            self.present(SearchBuilder.build(), animated: true)
        } else {
            self.lastSelectedTab = tabBarController.selectedIndex
        }
    }
}

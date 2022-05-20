import UIKit

final class TabBarBuilder {
    public static func build() -> TabBarViewController {
        let view = TabBarViewController()
        let router = TabBarRouter(view: view)
        let presenter = TabBarPresenter(view: view, router: router)
        view.presenter = presenter

        let selectedImageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .medium)
        view.viewControllers = [
                    self.createNavController(for: HomeBuilder.build(),
                                                       title: "",
                                                       image: UIImage(systemName: "house")!,
                                                       withVisibleTitle: false,
                                                       withSelectedImage: UIImage(systemName: "house.circle.fill",
                                                                                  withConfiguration: selectedImageConfig)),

                    self.createNavController(for: FavouritesListBuilder.build(),
                                                       title: "Favourites",
                                                       image: UIImage(systemName: "heart")!,
                                                       withVisibleTitle: true,
                                                       withSelectedImage: UIImage(systemName: "heart.circle.fill",
                                                                                  withConfiguration: selectedImageConfig)),

                    self.createNavController(for: UIViewController(),
                                                       title: "",
                                                       image: UIImage(systemName: "magnifyingglass")!,
                                                       withVisibleTitle: false,
                                                       withSelectedImage: nil)
                ]
        return view
    }

    private static func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage,
        withVisibleTitle titleVisible: Bool = false,
        withSelectedImage selectedImage: UIImage? = nil) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)

            navController.tabBarItem.image = image
            navController.tabBarItem.selectedImage = selectedImage

            if titleVisible {
                navController.navigationBar.prefersLargeTitles = true
                rootViewController.navigationItem.title = title
            }
            return navController
        }
}

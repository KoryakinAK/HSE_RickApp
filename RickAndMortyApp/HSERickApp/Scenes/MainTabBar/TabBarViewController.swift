import UIKit

protocol TabBarViewControllerProtocol: AnyObject {

}

final class TabBarViewController: UITabBarController, TabBarViewControllerProtocol {
    public var presenter: TabBarPresenterProtocol!
    private var loger = Loger(writers: [ConsoleWriter()], minLevel: .trace)

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupAppearance()
    }

    private func setupAppearance() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        tabBar.tintColor = UIColor(named: "mainLabelColor")
        tabBar.barTintColor = UIColor(named: "backgroundColor")
        tabBar.backgroundColor =  UIColor(named: "backgroundColor")
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            tabBarController.selectedIndex = presenter.lastSelectedTab
            self.present(SearchBuilder.build(with: loger), animated: true)
        } else {
            presenter.lastSelectedTab = tabBarController.selectedIndex
        }
    }
}

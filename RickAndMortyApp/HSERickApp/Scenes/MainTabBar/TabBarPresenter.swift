// 
//  TabBarPresenter.swift
//  HSERickApp
//
//  Created by Alexey Koryakin on 27.04.2022.
//

import UIKit

protocol TabBarPresenterProtocol: AnyObject {
    init(view: TabBarViewControllerProtocol, router: TabBarRouter)
    var lastSelectedTab: Int { get set }
    func didSelect(at selectedIndex: Int)
    func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage,
                                         withVisibleTitle titleVisible: Bool,
                                         withSelectedImage selectedImage: UIImage?) -> UIViewController
}

final class TabBarPresenter: TabBarPresenterProtocol {
    private weak var view: TabBarViewControllerProtocol?
    private var router: TabBarRouter

    var lastSelectedTab: Int = 0

    init(view: TabBarViewControllerProtocol, router: TabBarRouter) {
        self.view = view
        self.router = router
        UserDefaultsManager.sharedInstance().addToFavourites(id: 5)
        UserDefaultsManager.sharedInstance().addToFavourites(id: 6)
    }

    func createNavController(for rootViewController: UIViewController,
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
    
    func didSelect(at selectedIndex: Int) {
    }
}
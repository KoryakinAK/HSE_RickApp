// 
//  TabBarBuilder.swift
//  HSERickApp
//
//  Created by Alexey Koryakin on 27.04.2022.
//

import UIKit

final class TabBarBuilder {
    
    public static func build() -> TabBarViewController {
        let view = TabBarViewController()
        let router = TabBarRouter(view: view)
        let presenter = TabBarPresenter(view: view, router: router)
        
        view.presenter = presenter
        
        return view
    }
    
}

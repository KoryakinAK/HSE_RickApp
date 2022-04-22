// 
//  HomeBuilder.swift
//  HSERickApp
//
//  Created by Alexey Koryakin on 22.04.2022.
//

import UIKit

final class HomeBuilder {
    
    public static func build() -> HomeVC {
        let view = HomeVC()
        let presenter = HomePresenter(view: view)
        
        view.presenter = presenter
        
        return view
    }
    
}

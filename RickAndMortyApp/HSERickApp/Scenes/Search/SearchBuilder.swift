// 
//  SearchBuilder.swift
//  HSERickApp
//
//  Created by Alexey Koryakin on 22.04.2022.
//

import UIKit

final class SearchBuilder {
    
    public static func build() -> SearchViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter(view: view)
        
        view.presenter = presenter
        
        return view
    }
    
}

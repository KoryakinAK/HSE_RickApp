import UIKit

final class FavouritesListBuilder {

    public static func build() -> FavouritesListVC {
        let view = FavouritesListVC()
        let router = FavouritesListRouter(view: view)
        let storageManager = UserDefaultsManager.sharedInstance()
        let char = CharacterModel(id: 1, name: "Rick Sanchez",
                                  status: "Alive",
                                  species: "Human",
                                  gender: "Male",
                                  origin: LocationModel(
                                   name: "Earth (C-137)",
                                   url: "https://rickandmortyapi.com/api/location/1"),
                                  location: LocationModel(
                                   name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        storageManager.save(character: char, to: .favourites)
        let presenter = FavouritesListPresenter(view: view, router: router, storageManager: storageManager)
        view.presenter = presenter
        return view
    }
}

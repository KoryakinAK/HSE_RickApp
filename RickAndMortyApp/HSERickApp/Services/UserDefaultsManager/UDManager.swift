import Foundation

class UserDefaultsManager {
    private static let instance = UserDefaultsManager()
    private let favsKey = "Favourites"

    class func sharedInstance() -> UserDefaultsManager {
        return instance
    }

    private func getFavouritesArray() -> [Int] {
        guard
            let favouritesAsAny = UserDefaults.standard.value(forKey: favsKey),
            let favourites = favouritesAsAny as? [Int]
        else {
            return [Int]()
        }
        return favourites
    }

    func addToFavourites(id: Int) {
        var favourites = getFavouritesArray()
        if !favourites.contains(id) {
            favourites.append(id)
        }
        UserDefaults.standard.setValue(favourites, forKey: favsKey)
    }

    func removeFromFavourites(id: Int) {
        var favourites = getFavouritesArray()
        favourites = favourites.filter {$0 != id}
        UserDefaults.standard.setValue(favourites, forKey: favsKey)
    }

    func checkIfFavouritesContain(id: Int) -> Bool {
        let favourites = getFavouritesArray()
        return favourites.contains(id)
    }
}

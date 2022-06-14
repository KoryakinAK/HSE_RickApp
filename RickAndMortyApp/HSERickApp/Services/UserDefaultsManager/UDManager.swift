import Foundation
import Collections

protocol StorageProtocol {
    func save(character: CharacterModel, to: CharacterCategory)
    func getAllElementsIn(category: CharacterCategory) -> [CharacterModel]
    func attemptToRemove(character: CharacterModel, from category: CharacterCategory)
    func checkIfCurrentlyFavourited(_ character: CharacterModel) -> Bool
}

class UserDefaultsManager: StorageProtocol {
    private static let instance = UserDefaultsManager()
    class func sharedInstance() -> UserDefaultsManager {
        return instance
    }

    func save(character: CharacterModel, to category: CharacterCategory) {
        var currentCharacters = getAllElementsIn(category: category)
        if (currentCharacters.filter { $0.id == character.id }).isEmpty {
            currentCharacters.append(character)
        }

        if category == .recent {
            currentCharacters = currentCharacters.suffix(5)
        }

        UserDefaults.standard.set(try? PropertyListEncoder().encode(currentCharacters), forKey: category.rawValue)
    }

    func getAllElementsIn(category: CharacterCategory) -> [CharacterModel] {
        guard
            let data = UserDefaults.standard.value(forKey: category.rawValue) as? Data,
            let charactersArray = try? PropertyListDecoder().decode(Array<CharacterModel>.self, from: data)
        else {
            return [CharacterModel]()
        }
        return charactersArray
    }

    func attemptToRemove(character: CharacterModel, from category: CharacterCategory) {
        let filteredCharacters = getAllElementsIn(category: category)
            .filter { $0.id != character.id }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(filteredCharacters), forKey: category.rawValue)
    }

    func checkIfCurrentlyFavourited(_ character: CharacterModel) -> Bool {
        self.getAllElementsIn(category: .favourites).contains(character)
    }
}

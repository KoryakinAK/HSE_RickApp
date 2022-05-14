import Foundation

protocol StorageProtocol {
    func save(character: CharacterModel, to: CharacterCategory)
    func getCharactersIn(category: CharacterCategory) -> [CharacterModel]
}

class UserDefaultsManager: StorageProtocol {
    func save(character: CharacterModel, to category: CharacterCategory) {

        var currentCharacters = getCharactersIn(category: category)
        if (currentCharacters.filter { $0.id == character.id }).isEmpty {
            currentCharacters.append(character)
        }

//        UserDefaults.standard.setValue(currentCharacters, forKey: category.rawValue)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currentCharacters), forKey: category.rawValue)

    }

    func getCharactersIn(category: CharacterCategory) -> [CharacterModel] {
        guard
            let data = UserDefaults.standard.value(forKey: category.rawValue) as? Data,
            let charactersArray = try? PropertyListDecoder().decode(Array<CharacterModel>.self, from: data)
//            let charactersAsAny = UserDefaults.standard.value(forKey: category.rawValue),
//            let charactersArray = charactersAsAny as? [CharacterModel]
        else {
            return [CharacterModel]()
        }
        return charactersArray
    }

    private static let instance = UserDefaultsManager()
    class func sharedInstance() -> UserDefaultsManager {
        return instance
    }

    func getCharacterIDsIn(category: CharacterCategory) -> [UInt] {
        guard
            let characterIDsAsAny = UserDefaults.standard.value(forKey: category.rawValue),
            let characterIDs = characterIDsAsAny as? [UInt]
        else {
            return [UInt]()
        }
        return characterIDs
    }

    func add(id: UInt, to category: CharacterCategory) {
        var currentIDs = getCharacterIDsIn(category: category)
        if !currentIDs.contains(id) {
            currentIDs.append(id)
        }
        UserDefaults.standard.setValue(currentIDs, forKey: category.rawValue)
    }

    func remove(id: UInt, from category: CharacterCategory) {
        var currentIDs = getCharacterIDsIn(category: category)
        currentIDs = currentIDs.filter {$0 != id}
        UserDefaults.standard.setValue(currentIDs, forKey: category.rawValue)
    }

    // Необходимость функции под вопросом
    func checkIf(id: UInt, in category: CharacterCategory) -> Bool {
        let currentIDs = getCharacterIDsIn(category: category)
        return currentIDs.contains(id)
    }
}

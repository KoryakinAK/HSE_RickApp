import Foundation

class UserDefaultsManager {
    private static let instance = UserDefaultsManager()
    class func sharedInstance() -> UserDefaultsManager {
        return instance
    }

    enum DataCategory: String, CaseIterable {
        case favourites
        case recent
    }

    func getCharacterIDsIn(category: DataCategory) -> [UInt] {
        guard
            let characterIDsAsAny = UserDefaults.standard.value(forKey: category.rawValue),
            let characterIDs = characterIDsAsAny as? [UInt]
        else {
            return [UInt]()
        }
        return characterIDs
    }

    func add(id: UInt, to category: DataCategory) {
        var currentIDs = getCharacterIDsIn(category: category)
        if !currentIDs.contains(id) {
            currentIDs.append(id)
        }
        UserDefaults.standard.setValue(currentIDs, forKey: category.rawValue)
    }

    func remove(id: UInt, from category: DataCategory) {
        var currentIDs = getCharacterIDsIn(category: category)
        currentIDs = currentIDs.filter {$0 != id}
        UserDefaults.standard.setValue(currentIDs, forKey: category.rawValue)
    }

    // Необходимость функции под вопросом
    func checkIf(id: UInt, in category: DataCategory) -> Bool {
        let currentIDs = getCharacterIDsIn(category: category)
        return currentIDs.contains(id)
    }
}

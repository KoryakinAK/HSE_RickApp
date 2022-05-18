import Foundation
import OrderedCollections

struct CharacterModel: Codable, Equatable {
    let id: Int
    let name, status, species: String
    let gender: String
    let origin, location: LocationModel
    let image: String

    func asDictOfDescriptions() -> OrderedDictionary<String, String> {
        return ["Status": status,
                "Species": species,
                "Gender": gender,
                "Origin": origin.name]
    }

    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        lhs.id == rhs.id
    }
}

struct LocationModel: Codable, Equatable {
    let name: String
    let url: String
}

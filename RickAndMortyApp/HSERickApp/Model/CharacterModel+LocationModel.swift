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

    static let exampleCharacter = CharacterModel(id: 22,
                                             name: "Aqua Rick",
                                             status: "unknown",
                                             species: "Humanoid",
                                             gender: "Male",
                                             origin:
                                                LocationModel(
                                                    name: "unknown",
                                                    url: ""),
                                             location:
                                                LocationModel(
                                                    name: "Citadel of Ricks",
                                                    url: "https://rickandmortyapi.com/api/location/3"),
                                             image: "https://rickandmortyapi.com/api/character/avatar/22.jpeg")

}

struct LocationModel: Codable, Equatable {
    let name: String
    let url: String
}

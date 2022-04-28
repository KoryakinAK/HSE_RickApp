import Foundation

struct CharacterModel: Codable {
    let id: Int
    let name, status, species: String
    let gender: String
    let origin, location: LocationModel
    let image: String
    
    // TODO: - Вынести это из модели
    func AsDictOfDescriptions() -> [String: String] {
        return ["Status": status,
                "Species": species,
                "Gender": gender,
                "Origin": origin.name]
    }
}

struct LocationModel: Codable {
    let name: String
    let url: String
}

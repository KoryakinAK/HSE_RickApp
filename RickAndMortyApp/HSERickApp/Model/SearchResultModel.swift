import Foundation

struct SearchResultModel: Codable {
    let info: SearchMetaInfo
    let results: [CharacterModel]
}

struct SearchMetaInfo: Codable {
    let count, pages: Int
    let next, prev: URL?
}

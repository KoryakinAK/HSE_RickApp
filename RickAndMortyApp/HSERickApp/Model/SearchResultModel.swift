import Foundation

// MARK: - Welcome
struct SearchResultModel: Codable {
    let info: SearchMetaInfo
    let results: [CharacterModel]
}

// MARK: - Info
struct SearchMetaInfo: Codable {
    let count, pages: Int
    let next, prev: URL?
}

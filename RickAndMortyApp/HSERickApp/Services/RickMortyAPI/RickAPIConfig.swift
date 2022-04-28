import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
//    var parameters: [URLQueryItem] { get }
//    var token: URLQueryItem { get }
}

enum RickAPIConfig: Endpoint {
    case getCharacter(id: UInt)
    case getMultipleCharacters(ids: [UInt])

    var baseURL: String {
        switch self {
        default:
            return "rickandmortyapi.com"
        }
    }

    var path: String {
        switch self {
        case .getCharacter(let id):
            return "/api/character/\(id)"
        case .getMultipleCharacters(ids: let ids):
            let idsAsString = "\(ids)".filter { $0 != " "}
            return "/api/character/\(idsAsString)"
        }
    }

//    var parameters: [URLQueryItem] {
//        switch self {
//        case .getNews(let count):
//            let rangeItem = URLQueryItem(name: "range", value: "last-year")
//            let countItem = URLQueryItem(name: "limit", value: String(count))
//            return [rangeItem, countItem, token]
//        default:
//            return [token]
//        }
//    }
}

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem?] { get }
}

enum RickAPIEndpoint: Endpoint {
    case getCharacter(id: UInt)
    case getMultipleCharacters(ids: [UInt])
    case searchBy(name: String)

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
        case .searchBy:
            return "/api/character/"
        }
    }

    var parameters: [URLQueryItem?] {
        switch self {
        case .searchBy(let name):
            let nameParameter = URLQueryItem(name: "name", value: name)
            return [nameParameter]
        default:
            return [nil]
        }
    }
}

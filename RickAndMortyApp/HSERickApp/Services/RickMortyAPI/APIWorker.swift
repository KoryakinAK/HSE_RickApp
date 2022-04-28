import Foundation


protocol NetworkService: AnyObject {
    static func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
}

class APIWorker: NetworkService {

    static private func createURLComponents(endpoint: Endpoint) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = endpoint.baseURL
        components.path = endpoint.path
        return components
    }

    static func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = createURLComponents(endpoint: endpoint).url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3.0
        configuration.timeoutIntervalForResource = 3.0

        let session = URLSession(configuration: configuration)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            guard response != nil, let data = data else { return }
            DispatchQueue.main.async {
                if let responceObject = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(responceObject))
                } else {
                    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}

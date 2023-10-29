import Foundation

//protocol ApiProviderProtocol {
//    func login(for user: String, with password: String) -> String?
//    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)?)
//    func getLocations(for heroId: String?, token: String, completion: ((HeroLocations) -> Void)?)
//}

class ApiProvider {
    // MARK: - Constants
    static let shared: ApiProvider = .init()
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"

    private enum Endpoint {
        static let login = "/auth/login"
        static let heroes = "/heros/all"
        static let heroLocations = "/heros/locations"
    }
    
    enum NetworkError: Error {
        case unknown
        case malformedUrl
        case decodingFailed
        case encodingFailed
        case noData
        case statusCode(code: Int?)
        case noToken
    }


    // MARK: - Login
    func login(for user: String, with password: String, completion: @escaping  (Result<String, NetworkError>) -> Void) {
        var responseData: String = ""
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            completion(.failure(.malformedUrl))
            return
        }

        guard let loginData = String(format: "%@:%@", user, password)
            .data(using: .utf8)?.base64EncodedString() else {
            completion(.failure(.noData))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")

        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            let urlResponse = response as? HTTPURLResponse
            let statusCode = urlResponse?.statusCode
            
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }

            guard let data else {
                completion(.failure(.noData))
                return
            }


            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }

            responseData = String(data: data, encoding: .utf8) ?? ""

            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: [NotificationCenter.tokenKey: responseData]
            )
            
            completion(.success(responseData))

        }.resume()
        
    }

    
    // MARK: - Get heroes
    func getHeroes(by name: String?, token: String,  completion: @escaping  (Result<Heroes, NetworkError>) -> Void) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heroes)") else {
            completion(.failure(.malformedUrl))
            return
        }

        let jsonData: [String: Any] = ["name": name ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }

            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.statusCode(code: 200)))
                return
            }

            guard let heroes = try? JSONDecoder().decode(Heroes.self, from: data) else {
                // TODO: Enviar notificación indicando response error
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(heroes))
        }.resume()
    }

    
    // MARK: - Get locations for hero
    func getLocations(for heroId: String?, token: String,  completion: @escaping  (Result<HeroLocations, NetworkError>) -> Void) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heroLocations)") else {
            completion(.failure(.malformedUrl))
            return
        }

        let jsonData: [String: Any] = ["id": heroId ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)",  forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }

            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.statusCode(code: 200)))
                return
            }

            guard let heroLocations = try? JSONDecoder().decode(HeroLocations.self, from: data) else {
                // TODO: Enviar notificación indicando response error
                completion(.failure(.decodingFailed))
                return
            }

            completion(.success(heroLocations))
        }.resume()
    }
}

// MARK: - Extension notification center
extension NotificationCenter {
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
    static let tokenKey = "KEY_TOKEN"
}


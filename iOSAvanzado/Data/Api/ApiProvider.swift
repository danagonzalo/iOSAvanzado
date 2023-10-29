import Foundation

//protocol ApiProviderProtocol {
//    func login(for user: String, with password: String, completion: @escaping  ((Result<String, 
//        NetworkError>) -> Void))
//    func getHeroes(by name: String?, token: String,  completion: @escaping ((Result<Heroes, NetworkError>) -> Void))
//    func getLocations(for heroId: String?, token: String,  completion: @escaping ((Result<HeroLocations, NetworkError>) -> Void))
//}

public enum NetworkError: Error {
    case unknown
    case malformedUrl
    case decodingFailed
    case encodingFailed
    case noData
    case statusCode(code: Int?)
    case noToken
}

class ApiProvider {
    // MARK: - Constants
    static let shared: ApiProvider = .init()
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"


    
    private enum Endpoint {
        static let login = "/auth/login"
        static let heroes = "/heros/all"
        static let heroLocations = "/heros/locations"
    }
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Login
    func login(for user: String, with password: String, completion: @escaping  ((Result<String, NetworkError>) -> Void)) {

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

        
        session.dataTask(with: urlRequest) { (data, response, error) in
            
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

            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(token))            
        }.resume()
        
    }

    
    // MARK: - Get heroes
    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)? = nil) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heroes)") else {
            return
        }

        let jsonData: [String: Any] = ["name": name ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters

        session.dataTask(with: urlRequest) { (data, response, error) in
            var result: Heroes = []
            
            defer { completion?(result) }
            
            guard error == nil else {
                return
            }

            guard let data else {
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return
            }

            guard let heroes = try? JSONDecoder().decode(Heroes.self, from: data) else {
                return
            }
            
            result = heroes
        }.resume()
    }

    
    // MARK: - Get locations for hero
    func getLocations(for heroId: String?, token: String, completion: ((HeroLocations) -> Void)? = nil) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heroLocations)") else {
            return
        }

        let jsonData: [String: Any] = ["id": heroId ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)",  forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters

        session.dataTask(with: urlRequest) { (data, response, error) in
            var result: HeroLocations = []
            
            defer { completion?(result) }
            
            guard error == nil else {
                return
            }

            guard let data else {
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return
            }

            guard let heroLocations = try? JSONDecoder().decode(HeroLocations.self, from: data) else {
                return
            }

            result = heroLocations
        }.resume()
    }
}

// MARK: - Extension notification center
extension NotificationCenter {
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
    static let tokenKey = "KEY_TOKEN"
}


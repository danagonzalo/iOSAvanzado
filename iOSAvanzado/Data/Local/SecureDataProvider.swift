import Foundation
import KeychainSwift

protocol SecureDataProviderProtocol {
    func save(token: String)
    func getToken() -> String?
    func remove(token: String)
}

final class SecureDataProvider: SecureDataProviderProtocol {
    static let shared: SecureDataProvider = .init()
    private let keychain = KeychainSwift()

    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }

    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }

    func getToken() -> String? {
        keychain.get(Key.token)
    }
    
    func remove(token: String) {
        keychain.delete(Key.token)
    }
}

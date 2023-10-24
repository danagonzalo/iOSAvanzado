
import Foundation

class LoginViewModel: LoginViewControllerDelegate {
    // MARK: - Dependencies
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol

    // MARK: - Properties
    var viewState: ((LoginViewState) -> Void)?
    var heroesViewModel: HeroesListViewControllerDelegate {
        HeroesListViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }


    // MARK: - Initializers
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoginResponse),
            name: NotificationCenter.apiLoginNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Login button pressed
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))

        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Indique un email válido"))
                return
            }
            
            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Indique una contraseña válida"))
                return
            }
            
            self.doLoginWith(email: email ?? "", password: password ?? "")
        }
    }

    // MARK: - Private functions
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && (email?.contains("@") ?? false)
    }

    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }

    private func doLoginWith(email: String, password: String) {
        apiProvider.login(for: email, with: password)
    }
    
    // MARK: - Notification function
    @objc func onLoginResponse(_ notification: Notification) {
        defer { viewState?(.loading(false)) }

        guard let token = notification.userInfo?[NotificationCenter.tokenKey] as? String,
              !token.isEmpty else {
            return
        }

        secureDataProvider.save(token: token)
        viewState?(.navigateToNext)
    }
}

import Foundation


class SplashViewModel: SplashViewControllerDelegate {
    
    
    // MARK: - Dependencies
    private let secureDataProvider: SecureDataProviderProtocol
    
    var viewState: ((SplashViewState) -> Void)?
    
    lazy var loginViewModel: LoginViewControllerDelegate = {
        LoginViewModel(
            secureDataProvider: secureDataProvider
        )
    }()
    
    lazy var mapViewModel: MapViewControllerDelegate = {
        MapViewModel()
    }()


    lazy var heroesListViewModel: HeroesListViewControllerDelegate = {
        HeroesListViewModel(loginViewModel: loginViewModel,
                            mapViewModel: mapViewModel)
    }()

    private var isLogged: Bool {
        secureDataProvider.getToken()?.isEmpty == false
    }

    // MARK: - Initializers
    init(secureDataProvider: SecureDataProviderProtocol) {
        self.secureDataProvider = secureDataProvider
    }

    // MARK: - Lifecycle
    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
            self.isLogged ? self.viewState?(.navigateToHeroes) : self.viewState?(.navigateToLogin)
            SecureDataProvider.shared.isLogged = self.isLogged
            print("USER IS LOGGED FROM SPLASH: \(SecureDataProvider.shared.isLogged)")
        }
    }
}

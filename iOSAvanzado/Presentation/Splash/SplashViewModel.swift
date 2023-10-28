import Foundation


class SplashViewModel: SplashViewControllerDelegate {
    
    
    // MARK: - Dependencies
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    var viewState: ((SplashViewState) -> Void)?
    
    lazy var loginViewModel: LoginViewControllerDelegate = {
        LoginViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }()
    
    lazy var mapViewModel: MapViewControllerDelegate = {
        MapViewModel(apiProvider: apiProvider)
    }()


    lazy var heroesListViewModel: HeroesListViewControllerDelegate = {
        HeroesListViewModel(apiProvider: apiProvider,
                            loginViewModel: loginViewModel,
                            mapViewModel: mapViewModel)
    }()

    private var isLogged: Bool {
        secureDataProvider.getToken()?.isEmpty == false
    }

    // MARK: - Initializers
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }

    // MARK: - Lifecycle
    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
            self.isLogged ? self.viewState?(.navigateToHeroes) : self.viewState?(.navigateToLogin)
        }
    }
}

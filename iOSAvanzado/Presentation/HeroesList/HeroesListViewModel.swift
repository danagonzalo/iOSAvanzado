import Foundation

class HeroesListViewModel: HeroesListViewControllerDelegate {

    // MARK: - Dependencies
    private let apiProvider: ApiProviderProtocol


    // MARK: - Properties
    var loginVieModel: LoginViewControllerDelegate
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int { heroesList.count }

    var heroesList: Heroes = []

    // MARK: - Initializers
    init(apiProvider: ApiProviderProtocol,
         loginViewModel: LoginViewControllerDelegate) {
        self.apiProvider = apiProvider
        self.loginVieModel = loginViewModel
    }

    // MARK: - Public functions
    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            guard let token = SecureDataProvider.shared.getToken() else { return }

            self.apiProvider.getHeroes(by: nil, token: token) { heroes in
                self.heroesList = heroes
                self.viewState?(.updateData)
            }
        }
    }

    func heroBy(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            heroesList[index]
        } else {
            nil
        }
    }

    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerDelegate? {
        guard let selectedHero = heroBy(index: index) else { return nil }
        
        return HeroDetailViewModel(
            hero: selectedHero,
            apiProvider: apiProvider,
            secureDataProvider: SecureDataProvider.shared
        )
    }
    
    func onLogoutPressed() {
        // Borramos el token al cerrar sesión
        SecureDataProvider.shared.remove(token: SecureDataProvider.shared.getToken() ?? "")
        
    }
}

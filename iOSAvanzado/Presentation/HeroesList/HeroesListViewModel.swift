import Foundation
import CoreData

class HeroesListViewModel: HeroesListViewControllerDelegate {
    
    // MARK: - Properties
    private let database = Database()
    
    var loginVieModel: LoginViewControllerDelegate
    var mapViewModel: MapViewControllerDelegate
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int { heroesList.count }

    var heroesList: Heroes = []
    
    
    // MARK: - Initializers
    init(loginViewModel: LoginViewControllerDelegate,
         mapViewModel: MapViewControllerDelegate) {
        self.loginVieModel = loginViewModel
        self.mapViewModel = mapViewModel
    }

    
    // MARK: - Public functions
    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }
            guard let token = SecureDataProvider.shared.getToken() else { return }

            ApiProvider.shared.getHeroes(by: nil, token: token) { [weak self] heroes in
                
                DispatchQueue.main.async { [weak self] in
                    self?.database.deleteHeroesData()
                    try? self?.database.fetchHeroes(heroes.get())
                }
                
                try? self?.heroesList = heroes.get()
                self?.viewState?(.updateData)
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
            secureDataProvider: SecureDataProvider.shared
        )
    }
    
    func onLogoutPressed() {
        // Borramos el token al cerrar sesión
        DispatchQueue.main.async { [weak self] in
            self?.database.deleteAllData()
        }
        
        SecureDataProvider.shared.remove(token: SecureDataProvider.shared.getToken() ?? "")
    }
}

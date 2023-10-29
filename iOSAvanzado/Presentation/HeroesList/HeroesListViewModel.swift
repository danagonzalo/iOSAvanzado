import Foundation
import CoreData

class HeroesListViewModel: HeroesListViewControllerDelegate {
    
    // MARK: - Properties
    private let database: CoreDataStackProtocol
    
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
        self.database = CoreDataStack()
    }
    
    
    // MARK: - Public functions
    func onViewAppear() {
        viewState?(.loading(true))
        
        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }
            
            if SecureDataProvider.shared.isLogged {
                self?.heroesList = self?.database.fetchHeroes() ?? []
                self?.viewState?(.updateData)
            } else {
                ApiProvider.shared.getHeroes(by: "") { [weak self] heroes in
                    
                    self?.heroesList = heroes
                    
                    self?.database.deleteHeroesData()
                    self?.database.saveHeroes(heroes)
                    self?.viewState?(.updateData)
                }
                
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
        database.deleteAllData()
        
        
        SecureDataProvider.shared.remove(token: SecureDataProvider.shared.getToken() ?? "")
        SecureDataProvider.shared.isLogged = false
    }
}

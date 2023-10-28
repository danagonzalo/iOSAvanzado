import Foundation
import CoreData

class HeroesListViewModel: HeroesListViewControllerDelegate {
    
    // MARK: - Properties
    private let apiProvider: ApiProviderProtocol

    var loginVieModel: LoginViewControllerDelegate
    var mapViewModel: MapViewControllerDelegate
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int { heroesList.count }

    var heroesList: Heroes = []
    
    
    // MARK: - Initializers
    init(apiProvider: ApiProviderProtocol,
         loginViewModel: LoginViewControllerDelegate,
         mapViewModel: MapViewControllerDelegate) {
        self.apiProvider = apiProvider
        self.loginVieModel = loginViewModel
        self.mapViewModel = mapViewModel
    }

    
    // MARK: - Public functions
    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }
            guard let token = SecureDataProvider.shared.getToken() else { return }

            self?.apiProvider.getHeroes(by: nil, token: token) { [weak self] heroes in
                self?.deleteAllData()
                self?.fetchHeroes(heroes)
                self?.heroesList = heroes
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
            apiProvider: apiProvider,
            secureDataProvider: SecureDataProvider.shared
        )
    }
    
    func onLogoutPressed() {
        // Borramos el token al cerrar sesión
        deleteAllData()
        SecureDataProvider.shared.remove(token: SecureDataProvider.shared.getToken() ?? "")
    }
}

// MARK: - Extensions: CoreData
extension HeroesListViewModel {
    
    func fetchHeroes(_ heroesList: Heroes) {
        DispatchQueue.main.async { [weak self] in
            let context: NSManagedObjectContext = Database.context
            
            for hero in heroesList {
                let newHero = HeroDAO(context: context)
                
                newHero.id = hero.id
                newHero.name = hero.name
                newHero.longDescription = hero.description
                newHero.photo = hero.photo
                newHero.favorite = hero.isFavorite ?? false
            }
            
            try? Database.context.save()
            self?.viewState!(.updateData)
        }
    }
    
    func deleteAllData() {
        DispatchQueue.main.async {
            let delete = NSBatchDeleteRequest(fetchRequest: HeroDAO.fetchRequest())
            try? Database.context.execute(delete)
        }
    }
}

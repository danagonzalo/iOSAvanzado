import Foundation
import CoreData


final class MapViewModel: MapViewControllerDelegate {
    
    // MARK: - Properties
    private let database = Database()

    var heroLocationsList: HeroLocations = []
    var viewState: ((MapViewState) -> Void)?
    
    

    func onViewAppear() {
        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }
            
            DispatchQueue.main.async { [weak self] in
                self?.database.deleteLocationsData()
            }
            
            guard let token = SecureDataProvider.shared.getToken() else { return }
            
            ApiProvider.shared.getHeroes(by: "", token: token) { heroes in
                var heroesList: Heroes = []
                try? heroesList = heroes.get()
                
                for hero in heroesList {
                    self?.getLocations(for: hero, token: token)
                }
            }
        }
    }
    
    private func getLocations(for hero: Hero, token: String) {
        ApiProvider.shared.getLocations(for: hero.id, token: token) { [weak self] locations in
            DispatchQueue.main.async { [weak self] in
                try? self?.database.fetchLocations(for: hero.id ?? "", locations.get())
            }
            
            try? self?.heroLocationsList = locations.get()
            try? self?.viewState?(.loadData(hero: hero, locations: locations.get()))
        }
    }
}

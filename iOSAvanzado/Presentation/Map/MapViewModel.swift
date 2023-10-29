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
            
            
            ApiProvider.shared.getHeroes(by: "") { heroes in
                for hero in heroes {
                    self?.getLocations(for: hero)
                }
            }
        }
    }
    
    private func getLocations(for hero: Hero) {
        guard let heroId = hero.id else { return }
        
        ApiProvider.shared.getLocations(for: heroId) { [weak self] locations in
            DispatchQueue.main.async { [weak self] in
                self?.database.fetchLocations(for: heroId, locations)
            }
            
            self?.heroLocationsList = locations
            self?.viewState?(.loadData(hero: hero, locations: locations))
        }
    }
}

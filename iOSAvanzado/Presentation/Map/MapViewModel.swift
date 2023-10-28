import Foundation
import CoreData


final class MapViewModel: MapViewControllerDelegate {
    
    // MARK: - Properties
    private let database = Database()
    var heroLocationsList: HeroLocations = []
    var viewState: ((MapViewState) -> Void)?
    

    func onViewAppear() {
        print("I appeared!")
        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }
            
            DispatchQueue.main.async { [weak self] in
                self?.database.deleteLocationsData()
            }
            
            guard let token = SecureDataProvider.shared.getToken() else { return }
            
            ApiProvider.shared.getHeroes(by: "", token: token) { heroes in
                for hero in heroes {
                    self?.getLocations(for: hero, token: token)
                }
            }
        }
    }
    
    private func getLocations(for hero: Hero, token: String) {
        ApiProvider.shared.getLocations(for: hero.id, token: token) { [weak self] locations in
            DispatchQueue.main.async { [weak self] in
                self?.database.fetchLocations(for: hero.id ?? "", locations)
            }
            
            self?.heroLocationsList = locations
            self?.viewState?(.loadData(hero: hero, locations: locations))
        }
    }
}

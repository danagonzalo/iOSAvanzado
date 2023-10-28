import Foundation


final class MapViewModel: MapViewControllerDelegate {    
    
    // MARK: - Properties
    var viewState: ((MapViewState) -> Void)?
    
    func onViewAppear() {
        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }
            guard let token = SecureDataProvider.shared.getToken() else { return }
            
            ApiProvider.shared.getHeroes(by: "", token: token) { heroes in
                
                for hero in heroes {
                    self?.getLocations(for: hero)
                }
                
            }
        }
    }
    
    private func getLocations(for hero: Hero) {
        ApiProvider.shared.getLocations(for: hero.id,
                                        token: SecureDataProvider.shared.getToken() ?? "") { [weak self] locations in
            self?.viewState?(.loadData(hero: hero, locations: locations))

        }
    }
}

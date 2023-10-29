import Foundation


class HeroDetailViewModel: HeroDetailViewControllerDelegate {
    private let secureDataProvider: SecureDataProviderProtocol

    var viewState: ((HeroDetailViewState) -> Void)?
    private var hero: Hero
    private var heroLocations: HeroLocations = []

    // MARK: - Initializers
    init(hero: Hero,secureDataProvider: SecureDataProviderProtocol) {
        self.hero = hero
        self.secureDataProvider = secureDataProvider
    }

    func onViewAppear() {
        viewState?(.loading(true))

        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }
            
            ApiProvider.shared.getLocations(for: self?.hero.id ?? "") { [weak self] heroLocations in
                self?.heroLocations = heroLocations
                self?.viewState?(.update(hero: self?.hero, locations: heroLocations))
            }
        }
    }
}

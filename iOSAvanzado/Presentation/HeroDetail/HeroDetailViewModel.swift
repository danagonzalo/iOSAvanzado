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
            
            guard let token = self?.secureDataProvider.getToken() else { return }

            ApiProvider.shared.getLocations(for: self?.hero.id, token: token) { [weak self] heroLocations in
                try? self?.heroLocations = heroLocations.get()
                try? self?.viewState?(.update(hero: self?.hero, locations: heroLocations.get()))
            }
        }
    }
}

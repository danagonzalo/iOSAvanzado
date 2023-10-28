import Foundation


final class MapViewModel: MapViewControllerDelegate {
    
    // MARK: - Properties
//    var heroesIdList: String = []
    var heroesIdList: Heroes = []
    var viewState: ((MapViewState) -> Void)?
    
    func onViewAppear() {
        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            guard let token = SecureDataProvider.shared.getToken() else { return }

            ApiProvider.shared.getHeroes(by: "", token: token) { heroes in
//                for hero in heroes {
//                    heroesIdList.append(hero.id)
//                }
                self.heroesIdList = heroes
                self.viewState?(.loadData)
            }
        }
    }
}

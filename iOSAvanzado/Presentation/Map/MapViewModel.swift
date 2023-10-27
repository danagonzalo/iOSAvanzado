import Foundation


final class MapViewModel: MapViewControllerDelegate {
    
    // MARK: - Properties
    var heroesList: Heroes = []
    var viewState: ((MapViewState) -> Void)?
    
    func onViewAppear() {
        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            guard let token = SecureDataProvider.shared.getToken() else { return }

            ApiProvider.shared.getHeroes(by: "", token: token) { heroes in
                print("Hero 1  in map: \(String(describing: heroes.first))")
                self.heroesList = heroes
                self.viewState?(.updateData)
            }
            
            // TODO: For hero in heroesList...
        }
    }
}

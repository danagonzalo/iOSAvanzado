import Foundation
import CoreData


final class MapViewModel: MapViewControllerDelegate {
    
    
    // MARK: - Properties
    
    var heroLocationsList: HeroLocations = []
    var viewState: ((MapViewState) -> Void)?
    

    func onViewAppear() {
        DispatchQueue.global().async { [weak self] in
            defer { self?.viewState?(.loading(false)) }
            
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
            self?.heroLocationsList = locations
            self?.viewState?(.loadData(hero: hero, locations: locations))

        }
    }
}


// MARK: - Extensions: CoreData
extension MapViewModel {

    func fetchLocations(_ locations: HeroLocations) {
    DispatchQueue.main.async {
        let context: NSManagedObjectContext = Database.context
        
        for location in locations {
            
            let entity = NSEntityDescription.entity(forEntityName: "HeroDAO", in: context)
            let hero = NSManagedObject(entity: entity!, insertInto: context)
            
            let newLocation = LocationDAO(context: context)
            
            newLocation.id = location.id
            newLocation.date = location.date
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            // TODO: newLocation.hero = location.longitud, como pasar HERO -> HERODAO?
            
        }
        
        try? context.save()
    }
}

    func deleteAllData() {
        let context: NSManagedObjectContext = Database.context
        let delete = NSBatchDeleteRequest(fetchRequest: LocationDAO.fetchRequest())
        try? context.execute(delete)
    }
}

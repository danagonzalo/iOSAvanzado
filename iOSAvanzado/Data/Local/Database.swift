import Foundation
import UIKit
import CoreData

public protocol DatabaseProtocol {
    func fetchHeroes(_ heroesList: Heroes)
    func fetchLocations(for heroId: String, _ locations: HeroLocations)
    func getHero(by heroId: String) -> HeroDAO?
    func deleteHeroesData()
    func deleteLocationsData()
    func deleteAllData()
}

final class Database: DatabaseProtocol {
    
    // MARK: - Properties
    private var context: NSManagedObjectContext?
    
    
    // MARK: - Initializer
    init() {
        DispatchQueue.main.async {
            self.context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            self.context?.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        }
    }

    
    // MARK: - Fetch heroes
    func fetchHeroes(_ heroesList: Heroes) {
        for hero in heroesList {
            let newHero = HeroDAO(context: context!)
            
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.longDescription = hero.description
            newHero.photo = hero.photo
            newHero.favorite = hero.isFavorite ?? false
        }
        
        try? context!.save()
    }
    
    
    // MARK: - Fetch locations
    func fetchLocations(for heroId: String, _ locations: HeroLocations) {
        for location in locations {
            let newLocation = LocationDAO(context: context!)
            
            newLocation.id = location.id
            newLocation.date = location.date
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            newLocation.hero = getHero(by: heroId)
        }
    
        try? context!.save()
    }
    
    func getHero(by heroId: String) -> HeroDAO? {
        let hero: HeroDAO?
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        fetchHero.predicate = NSPredicate(format: "id = '\(heroId)'")
        
        hero = try? context!.fetch(fetchHero).first
        
        return hero
    }

    
    // MARK: - Deleting data
    func deleteHeroesData() {
        let delete = NSBatchDeleteRequest(fetchRequest: HeroDAO.fetchRequest())
        try? context!.execute(delete)
        
    }
    
    func deleteLocationsData() {
        let delete = NSBatchDeleteRequest(fetchRequest: LocationDAO.fetchRequest())
        try? context!.execute(delete)
    }

    func deleteAllData() {
        deleteHeroesData()
        deleteLocationsData()
    }
}

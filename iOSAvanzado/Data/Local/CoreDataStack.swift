import Foundation
import UIKit
import CoreData

protocol ManagedObjectConvertible {
    associatedtype ManagedObject
    
    /// Converts a conforming instance to a managed object instance.
    ///
    /// - Parameter context: The managed object context to use.
    /// - Returns: The converted managed object instance.
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject?
}

/// Protocol to provide functionality for data model conversion.
protocol ModelConvertible {
    associatedtype Model
    
    /// Converts a conforming instance to a data model instance.
    ///
    /// - Returns: The converted data model instance.
    func toModel() -> Model?
}

public protocol CoreDataStackProtocol {
    func saveHeroes(_ heroesList: Heroes)
    func saveHeroLocations(for heroId: String, _ locations: HeroLocations)
    func getHero(by heroId: String) -> HeroDAO?
    func fetchHeroes() -> Heroes
    func fetchHeroLocations() -> HeroLocations
    func deleteHeroesData()
    func deleteLocationsData()
    func deleteAllData()
}

class CoreDataStack: CoreDataStackProtocol {
    
    // MARK: - Properties
    private var context: NSManagedObjectContext!
    
    // MARK: - Persistent container
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iOSAvanzado")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Initializer
    init() {
        //        DispatchQueue.main.async {
        self.context = CoreDataStack.persistentContainer.viewContext
        self.context.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        //        }
    }
    
    // MARK: Fetch data
    //    func fetchHeroes() -> [HeroDAO]? {
    //        let fetchRequest = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
    //        let heroes = try? context.fetch(fetchRequest)
    //
    //        return heroes
    //    }
    func fetchHeroes() -> Heroes {
        //        let managedObjectContext = persistentContainer.viewContext
        var heroes: [HeroDAO] = []
        do {
            let fetchRequest = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
            heroes = try context.fetch(fetchRequest)
        } catch {
            print("--------\(error)")
        }
        
        var newList: Heroes = []
        heroes.forEach {
            newList.append($0.toModel()!)
        }
        
        print("MEWLIST COUNT COREDATA: \(newList.count)")
        
        return newList
    }
    
    func fetchHeroLocations() -> HeroLocations {
        var locations: [LocationDAO] = []
        do {
            let fetchRequest = NSFetchRequest<LocationDAO>(entityName: "LocationDAO")
            locations = try context.fetch(fetchRequest)
        } catch {
            print("--------\(error)")
        }
        
        var newList: HeroLocations = []
        locations.forEach {
            newList.append($0.toModel()!)
        }
        
        
        return newList
        
    }
    
    // MARK: - Save data
    func saveHeroes(_ heroesList: Heroes) {
        for hero in heroesList {
            let newHero = HeroDAO(context: context)
            
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.longDescription = hero.description
            newHero.photo = hero.photo
            newHero.favorite = hero.isFavorite ?? false
        }
        
        do {
            try context.save()
            print("SUCCESS SAVING!")
        } catch {
            print("ERRROR SAVING: \(error)")
        }
        
    }
    
    
    // MARK: - Fetch locations
    func saveHeroLocations(for heroId: String, _ locations: HeroLocations) {
        for location in locations {
            let newLocation = LocationDAO(context: context)
            
            newLocation.id = location.id
            newLocation.date = location.date
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            newLocation.hero = getHero(by: heroId)
        }
        
        try? context.save()
    }
    
    // MARK: - Fetch one hero
    func getHero(by heroId: String) -> HeroDAO? {
        let hero: HeroDAO?
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        fetchHero.predicate = NSPredicate(format: "id = '\(heroId)'")
        
        hero = try? context.fetch(fetchHero).first
        
        return hero
    }
    
    // MARK: - Fetch one location
    func getLocation(by id: String) -> LocationDAO? {
        let location: LocationDAO?
        let fetchLocation = NSFetchRequest<LocationDAO>(entityName: "LocationDAO")
        fetchLocation.predicate = NSPredicate(format: "id = '\(id)'")
        
        location = try? context.fetch(fetchLocation).first
        
        return location
    }
    
    
    // MARK: - Delete data
    func deleteHeroesData() {
        let heroes = fetchHeroes()
        
        for hero in heroes {
            let heroToDelete = getHero(by: hero.id!)!
            context.delete(heroToDelete)
        }
    }
    
    func deleteLocationsData() {
        let locations = fetchHeroLocations()
        
        for location in locations {
            let locationToDelete = getLocation(by: location.id!)!
            context.delete(locationToDelete)
        }
    }
    
    func deleteAllData() {
        deleteHeroesData()
        deleteLocationsData()
    }
}

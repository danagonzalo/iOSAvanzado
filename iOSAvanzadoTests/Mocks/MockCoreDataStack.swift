import XCTest
import CoreData
import iOSAvanzado

struct MockCoreDataStack {
    
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    let mockApiService: ApiProviderProtocol
    
    init() {
        mockApiService = MockApiProvider()

        persistentContainer = NSPersistentContainer(name: "iOSAvanzado")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.automaticallyMergesChangesFromParent = true
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
}

// MARK: - Protocol
extension MockCoreDataStack: CoreDataStackProtocol {
    
    func getHero(by heroId: String) -> iOSAvanzado.HeroDAO? {
        let hero: HeroDAO?
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        fetchHero.predicate = NSPredicate(format: "id = '\(heroId)'")
        
        hero = try? context.fetch(fetchHero).first
        
        return hero
    }
    
    
    func saveHeroes(_ heroesList: iOSAvanzado.Heroes) {
        for hero in heroesList {
            let newHero = HeroDAO(context: context)
            
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.longDescription = hero.description
            newHero.photo = hero.photo
            newHero.favorite = hero.isFavorite ?? false
        }
        
        try? context.save()
    }
    
    func saveHeroLocations(for heroId: String, _ locations: iOSAvanzado.HeroLocations) {
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
    
    func fetchHeroes() -> [iOSAvanzado.HeroDAO]? {
        let fetchRequest = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        let heroes = try? context.fetch(fetchRequest)
        
        return heroes
    }
    
    func fetchHeroLocations() -> [iOSAvanzado.LocationDAO]? {
        let fetchRequest = NSFetchRequest<LocationDAO>(entityName: "LocationDAO")
        let locations = try? context.fetch(fetchRequest)
        
        
        return locations
    }
    
    func deleteHeroesData() {
        let heroes = fetchHeroes()
        
        heroes?.forEach {
            context.delete($0)
        }
    }
    
    func deleteLocationsData() {
        let locations = fetchHeroLocations()
        
        locations?.forEach {
            context.delete($0)
        }
    }
    
    func deleteAllData() {
        deleteHeroesData()
        deleteLocationsData()
    }
}

// MARK: - Other functions
extension MockCoreDataStack {
    func fetchHero(by heroName: String) -> [HeroDAO]? {
        let fetchRequest = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", heroName)
        
        let heroFetched = try? context.fetch(fetchRequest)
        return heroFetched
    }
}

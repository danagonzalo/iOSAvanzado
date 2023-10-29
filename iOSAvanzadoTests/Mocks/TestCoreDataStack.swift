import XCTest
import CoreData
import iOSAvanzado

struct TestCoreDataStack {
    
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    let mockApiService: ApiProviderProtocol
    
    init() {
        persistentContainer = NSPersistentContainer(name: "iOSAvanzado")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
        
        mockApiService = MockApiService()
    }
}

// MARK: - Protocol
extension TestCoreDataStack: CoreDataStackProtocol {
    
    func getHero(by heroId: String) -> iOSAvanzado.HeroDAO? {
        let hero: HeroDAO?
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        fetchHero.predicate = NSPredicate(format: "id = '\(heroId)'")
        
        hero = try? mainContext.fetch(fetchHero).first
        
        return hero
    }
    
    
    func saveHeroes(_ heroesList: iOSAvanzado.Heroes) {
        for hero in heroesList {
            let newHero = HeroDAO(context: mainContext)
            
            newHero.id = hero.id
            newHero.name = hero.name
            newHero.longDescription = hero.description
            newHero.photo = hero.photo
            newHero.favorite = hero.isFavorite ?? false
        }
        
        try? mainContext.save()
    }
    
    func saveHeroLocations(for heroId: String, _ locations: iOSAvanzado.HeroLocations) {
        for location in locations {
            let newLocation = LocationDAO(context: mainContext)
            
            newLocation.id = location.id
            newLocation.date = location.date
            newLocation.latitude = location.latitude
            newLocation.longitude = location.longitude
            newLocation.hero = getHero(by: heroId)
        }
        
        try? mainContext.save()
    }
    
    func fetchHeroes() -> [iOSAvanzado.HeroDAO]? {
        let fetchRequest = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        let heroes = try? mainContext.fetch(fetchRequest)
        
        return heroes
    }
    
    func fetchHeroLocations() -> [iOSAvanzado.LocationDAO]? {
        let fetchRequest = NSFetchRequest<LocationDAO>(entityName: "LocationDAO")
        let locations = try? mainContext.fetch(fetchRequest)
        
        
        return locations
    }
    
    func deleteHeroesData() {
        let heroes = fetchHeroes()
        
        heroes?.forEach {
            mainContext.delete($0)
        }
    }
    
    func deleteLocationsData() {
        let locations = fetchHeroLocations()
        
        locations?.forEach {
            mainContext.delete($0)
        }
    }
    
    func deleteAllData() {
        deleteHeroesData()
        deleteLocationsData()
    }
}

// MARK: - Other functions
extension TestCoreDataStack {
    func fetchHero(by heroName: String) -> [HeroDAO]? {
        let fetchRequest = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", heroName)
        
        let heroFetched = try? mainContext.fetch(fetchRequest)
        return heroFetched
    }
}

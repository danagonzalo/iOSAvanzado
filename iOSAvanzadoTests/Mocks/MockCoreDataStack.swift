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
    
    func fetchHeroes() -> iOSAvanzado.Heroes {
        var heroesList: Heroes = []
        mockApiService.getHeroes(by: "") { heroes in
            heroesList = heroes
        }
        
        return heroesList
    }
    
    func fetchHeroLocations() -> iOSAvanzado.HeroLocations {
        var locationsList: HeroLocations = []
        let heroesList: Heroes = fetchHeroes()
        
        for hero in heroesList {
            mockApiService.getLocations(for: hero.id ?? "") { locations in
                locationsList = locations
            }
        }
        
        return locationsList
    }
    
    func getLocation(by id: String) -> iOSAvanzado.LocationDAO? {
        let location: LocationDAO?
        
        let fetchLocation = NSFetchRequest<LocationDAO>(entityName: "LocationDAO")
        fetchLocation.predicate = NSPredicate(format: "id = '\(id)'")
        
        location = try? context.fetch(fetchLocation).first
        
        return location
    }
    
    func getLocations(for heroId: String) -> iOSAvanzado.HeroLocations {
        var locationsList: HeroLocations = []
        
        mockApiService.getLocations(for: heroId) { locations in
            locationsList = locations
        }
        
        return locationsList
    }
    
    
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

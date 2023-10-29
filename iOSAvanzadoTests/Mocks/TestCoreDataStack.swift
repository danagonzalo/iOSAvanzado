import XCTest
import CoreData
import iOSAvanzado

struct TestCoreDataStack {
    
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
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
    }
}

extension TestCoreDataStack: CoreDataStackProtocol {
    
    func saveHeroes(_ heroesList: iOSAvanzado.Heroes) {
        let hero1 = HeroDAO(context: mainContext)
        hero1.name = "Goku"
        
        let hero2 = HeroDAO(context: mainContext)
        hero2.name = "Vegeta"
        
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
    
    func saveHeroLocations(for heroId: String, _ locations: iOSAvanzado.HeroLocations) {
        let location = LocationDAO(context: mainContext)
        location.id = "someId"
        
        try? mainContext.save()
    }
    
    func deleteHeroesData() {
        let delete = NSBatchDeleteRequest(fetchRequest: HeroDAO.fetchRequest())
        try? mainContext.execute(delete)
    }
    
    func deleteLocationsData() {
        let delete = NSBatchDeleteRequest(fetchRequest: LocationDAO.fetchRequest())
        try? mainContext.execute(delete)
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

import Foundation
import CoreData
import iOSAvanzado

class MockDatabase: DatabaseProtocol {
    private let mockApiProvider = MockApiService()
    private let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    
    func fetchHeroes(_ heroesList: iOSAvanzado.Heroes) {
        mockApiProvider.getHeroes(by: "") { [weak self] heroes in
            for hero in heroes {
                let newHero = HeroDAO(context: self!.context)
                
                newHero.id = hero.id
                newHero.name = hero.name
                newHero.longDescription = hero.description
                newHero.photo = hero.photo
                newHero.favorite = hero.isFavorite ?? false
            }
        }
        
        try? context.save()
    }
    
    func fetchLocations(for heroId: String, _ locations: iOSAvanzado.HeroLocations) {
        <#code#>
    }
    
    func getHero(by heroId: String) -> iOSAvanzado.HeroDAO? {
        <#code#>
    }
    
    func deleteHeroesData() {
        <#code#>
    }
    
    func deleteLocationsData() {
        <#code#>
    }
    
    func deleteAllData() {
        <#code#>
    }
    
    
}

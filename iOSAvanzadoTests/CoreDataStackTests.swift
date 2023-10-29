import XCTest
import CoreData
@testable import iOSAvanzado

final class CoreDataStackTests: XCTestCase {
    
    private var sut: TestCoreDataStack!
    
    override func setUp() {
        sut = TestCoreDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
        
    
    
    func test_whenSaveHero_fetchHeroSuccess() {
        let context = sut.persistentContainer.viewContext
        let heroName = "Goku"
        
        let hero = HeroDAO(context: context)
        hero.name = heroName
        
        try? context.save()
        
        let heroFetched = sut.fetchHero(by: heroName)
        
        XCTAssertEqual(heroFetched?.count, 1)
        XCTAssertEqual(heroFetched?.first?.name, heroName)
    }
    
    func test_whenFetchHero_thenHeroDoesNotExist() {
        let someName = "SomeName"
        let heroFetched = sut.fetchHero(by: someName)
        
        XCTAssertEqual(heroFetched?.count, 0)
        XCTAssertNil(heroFetched?.first?.name, someName)
    }
    
}

import XCTest
import CoreData
@testable import iOSAvanzado

final class CoreDataStackTests: XCTestCase {
    
    private var sut: MockCoreDataStack!
    private var mockApiService: ApiProviderProtocol!
    private var heroesList: Heroes!
    private var locationsList: HeroLocations!
    private var someHeroId: String = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
    
    override func setUp() {
        sut = MockCoreDataStack()
        mockApiService = MockApiProvider()
        
        mockApiService.getHeroes(by: "") { [weak self] heroes in
            self?.heroesList = heroes
        }
        
        mockApiService.getLocations(for: someHeroId) { [weak self] locations in
            self?.locationsList = locations
        }
    }
    
    override func tearDown() {
        super.tearDown()
        mockApiService = nil
        sut = nil
        heroesList = nil
        locationsList = nil
    }
        
    
    // MARK: - Save heroes
    func test_saveHeroes() throws {
        sut.saveHeroes(heroesList)
                
        let expectation = self.expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: sut.context) { _ in
                return true
        }
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    // MARK: - Fetch one hero
    func test_fetchHero() throws {
        let expectation = self.expectation(description: "Fetch one hero - Goku")
        
        sut.saveHeroes(heroesList)
        let heroFetched = sut.getHero(by: someHeroId)
        
        XCTAssertNotNil(heroFetched)
        XCTAssertEqual(heroFetched?.name, "Goku")
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Fetch heroes
    func test_fetchHeroes() throws {
        let expectation = self.expectation(description: "Fetch all heroes")
        
        sut.saveHeroes(heroesList)
        
        
        let heroes = sut.fetchHeroes()
        
        XCTAssertNotNil(heroes)
        XCTAssertEqual(heroes.count, 2)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    // MARK: - Delete heroes
    func test_deleteHeroes() throws {
        let expectation = self.expectation(description: "Delete all heroes")

        sut.saveHeroes(heroesList)
        sut.deleteHeroesData()
        
        let heroesFetched = sut.fetchHeroes()
        
        XCTAssertEqual(heroesFetched.count, 0)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    // MARK: - Save locations
    func test_saveLocations() throws {
        sut.saveHeroLocations(for: someHeroId, locationsList)
                
        let expectation = self.expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: sut.context) { _ in
                return true
        }
        
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - Fetch locations
    func test_fetchLocations() throws {
        let expectation = self.expectation(description: "Fetch all locations")
        
        sut.saveHeroLocations(for: someHeroId, locationsList)
        
        let locations = sut.fetchHeroLocations()
        
        XCTAssertNotNil(locations)
        XCTAssertEqual(locations.count, 5)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }

    
    // MARK: - Delete locations
    func test_deleteLocations() throws {
        let expectation = self.expectation(description: "Delete all locations")

        sut.saveHeroLocations(for: someHeroId, locationsList)
        sut.deleteLocationsData()
        
        let locationsFetched = sut.fetchHeroLocations()
        
        XCTAssertEqual(locationsFetched.count, 0)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }
}

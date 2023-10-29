import XCTest
@testable import iOSAvanzado

final class ApiProviderTests: XCTestCase {
    
    private var sut: ApiProviderProtocol!
    
    override func setUp() {
        super.setUp()
        sut = MockApiProvider()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_whenGetAllHeroes_thenHeroesExist() throws {
        let expectation = self.expectation(description: "Get all heroes")
        
        sut.getHeroes(by: "") { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_whenGetOneHero_thenHeroExists() throws {
        let expectation = self.expectation(description: "Get one hero")
        let heroName = "Goku"
        sut.getHeroes(by: heroName) { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.name ?? "", heroName)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_whenGetOneHero_thenHeroDoesNotExist() throws {
        let expectation = self.expectation(description: "Get one hero")
        let heroName = "SomeHeroName"
        
        sut.getHeroes(by: heroName) { result in
            XCTAssertEqual(result.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func test_whenGivenHeroId_locationsExist() throws {
        let expectation = self.expectation(description: "Get all locations for hero")
        let heroId = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
        
        sut.getLocations(for: heroId) { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result.count, 5)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_whenGivenHeroId_locationsDoNotExist() throws {
        let expectation = self.expectation(description: "Get all locations for hero")
        let heroId = "SomeId"
        
        sut.getLocations(for: heroId) { result in
            XCTAssertEqual(result.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}

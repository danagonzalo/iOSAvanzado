import XCTest
@testable import iOSAvanzado


final class DatabaseTests: XCTestCase {
    private var sut: DatabaseProtocol!
    
    override func setUp() {
        super.setUp()
        sut = MockDatabase()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    func test_fetchHeroes() {
        sut.fetchHeroes(<#T##heroesList: Heroes##Heroes#>)
    }

}

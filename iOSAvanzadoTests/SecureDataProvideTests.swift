import XCTest
@testable import iOSAvanzado

final class SecureDataProvideTests: XCTestCase {
    private var sut: SecureDataProviderProtocol!
    
    override func setUp() {
        sut = SecureDataProvider()
    }
    
    
    func test_whenLoadToken_thenGetCorrectToken() throws {
        let token = "SomeToken"
        sut.save(token: token)
        let tokenLoaded = sut.getToken()
        
        XCTAssertEqual(token, tokenLoaded)
    }

    func test_whenRemoveToken_thenTokenIsRemoved() {
        let token = "SomeToken"
        sut.remove(token: token)
        
        XCTAssertNil(sut.getToken())
    }
}

import XCTest
@testable import iOSAvanzado

final class SecureDataProvideTests: XCTestCase {
    private var sut: SecureDataProviderProtocol!
    
    override func setUp() {
        sut = SecureDataProvider()
    }
    
    func test_whenLoadToken_thenGetCorrectToken() throws {
        let expectation = self.expectation(description: "Get token")

        let token = "SomeToken"
        sut.save(token: token)
        let tokenLoaded = sut.getToken()
        
        XCTAssertEqual(token, tokenLoaded)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }

    func test_whenRemoveToken_thenTokenIsRemoved() throws {
        let expectation = self.expectation(description: "Remove token")

        let token = "SomeToken"
        sut.remove(token: token)
        XCTAssertNil(sut.getToken())
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 10.0)
    }
}

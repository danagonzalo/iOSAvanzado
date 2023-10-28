import XCTest
@testable import iOSAvanzado

final class iOSAvanzadoTests: XCTestCase {

    private var sut: ApiProvider!
    private var dataProvider: SecureDataProvider!
    private var token: String!
    
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
        token = "Some-Token"
        dataProvider = SecureDataProvider()
        sut = ApiProvider()
        
        try? testDoMockLogin()
    }
    
    func testGetHeroes() throws {
        let expectation = self.expectation(description: "Success")
        sut.getHeroes(by: "", token: token) { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result.count, 16)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetLocations() throws {
        let expectation = self.expectation(description: "Success")
        let heroId = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
        
        sut.getLocations(for: heroId, token: token) { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result.count, 17)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetNoLocations() throws {
        let expectation = self.expectation(description: "Success")
        let heroId = "F63A463D-7F49-4DF9-99B8-6FD04EEF10A9"
        
        sut.getLocations(for: heroId, token: token) { result in
            XCTAssertNil(result)
            XCTAssertEqual(result.count, 17)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testDoMockLogin() throws {
        let expectation = self.expectation(description: "Success")

        let someUser = "SomeUser"
        let somePassword = "SomePassword"
        
        MockURLProtocol.requestHandler = { [weak self] request in
            let loginString = String(format: "%@:%@", someUser, somePassword)
            let loginData = loginString.data(using: .utf8)!
            let base64LogingString = loginData.base64EncodedString()

            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Bearer \(String(describing: self?.token))"
            )
            
            
            let data = try XCTUnwrap(self?.token.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            
            return (response, data)
        }
                
        sut.login(for: someUser, with: somePassword)
        XCTAssertEqual(token, "Some-Token")

        expectation.fulfill()

        wait(for: [expectation], timeout: 10.0)
    }
    
    // MARK: - OHHTTPStubs
    final class MockURLProtocol: URLProtocol {
        static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let handler = MockURLProtocol.requestHandler else {
                assertionFailure("Received unexpected request with no handler")
                return
            }
            
            do {
                let (response, data) = try handler(request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
}

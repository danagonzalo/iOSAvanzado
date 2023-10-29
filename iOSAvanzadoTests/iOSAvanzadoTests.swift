import XCTest
@testable import iOSAvanzado

final class iOSAvanzadoTests: XCTestCase {
    
    private var sut: MockApiService!
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    override func setUp() {
        super.setUp()
        //        let configuration = URLSessionConfiguration.ephemeral
        //        configuration.protocolClasses = [MockURLProtocol.self]
        
        //        let session = URLSession(configuration: configuration)
        sut = MockApiService()
        //        try? testDoMockLogin()
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
        let heroName = "ABC"
        sut.getHeroes(by: heroName) { result in
            XCTAssertEqual(result.count, 0)

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
//    func testGetLocations() throws {
//        let expectation = self.expectation(description: "Success")
//        let heroId = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
//        
//        sut.getLocations(for: heroId) { result in
//            XCTAssertNotNil(result)
//            XCTAssertEqual(result.count, 17)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 10.0)
//    }
//    
//    func testGetNoLocations() throws {
//        let expectation = self.expectation(description: "Success")
//        let heroId = "F63A463D-7F49-4DF9-99B8-6FD04EEF10A9"
//        
//        sut.getLocations(for: heroId) { result in
//            XCTAssertNil(result)
//            XCTAssertEqual(result.count, 17)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 10.0)
//    }
}
    
    //    func testDoMockLogin() throws {
    //        let expectation = self.expectation(description: "Login success")
    //
    //        let someToken = ""
    //        let expectedToken = "SomeToken"
    //        let someUser = "SomeUser"
    //        let somePassword = "SomePassword"
    //
    //        MockURLProtocol.requestHandler = { request in
    //            let loginString = String(format: "%@:%@", someUser, somePassword)
    //            let loginData = loginString.data(using: .utf8)!
    //            let base64LogingString = loginData.base64EncodedString()
    //
    //            XCTAssertEqual(request.httpMethod, "POST")
    //            XCTAssertEqual(
    //                request.value(forHTTPHeaderField: "Authorization"),
    //                "Bearer \(someToken)"
    //            )
    //
    //            let data = try XCTUnwrap(expectedToken.data(using: .utf8))
    //            let response = try XCTUnwrap(
    //                HTTPURLResponse(
    //                    url: URL(string: "https://dragonball.keepcoding.education")!,
    //                    statusCode: 200,
    //                    httpVersion: nil,
    //                    headerFields: ["Content-Type": "application/json"]
    //                )
    //            )
    //            return (response, data)
    //        }
    //
    //        sut.login(for: someUser, with: somePassword) { result in
    //            guard case let .success(token) = result else {
    //                XCTFail("Expected success but received \(result)")
    //                return
    //            }
    //
    //            XCTAssertEqual(token, expectedToken)
    //            expectation.fulfill()
    //        }
    //
    //        wait(for: [expectation], timeout: 10.0)
    //    }
    //
    //    // MARK: - OHHTTPStubs
    //    final class MockURLProtocol: URLProtocol {
    //        static var error: ApiProvider.NetworkError?
    //        static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    //
    //        override class func canInit(with request: URLRequest) -> Bool {
    //            return true
    //        }
    //
    //        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    //            return request
    //        }
    //
    //        override func startLoading() {
    //            if let error = MockURLProtocol.error {
    //                client?.urlProtocol(self, didFailWithError: error)
    //                return
    //            }
    //
    //            guard let handler = MockURLProtocol.requestHandler else {
    //                assertionFailure("Received unexpected request with no handler")
    //                return
    //            }
    //
    //            do {
    //                let (response, data) = try handler(request)
    //                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    //                client?.urlProtocol(self, didLoad: data)
    //                client?.urlProtocolDidFinishLoading(self)
    //            } catch {
    //                client?.urlProtocol(self, didFailWithError: error)
    //            }
    //        }
    //
    //        override func stopLoading() { }
    //    }}


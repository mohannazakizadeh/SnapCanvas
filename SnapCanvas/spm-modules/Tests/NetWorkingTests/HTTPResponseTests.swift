//
//  HTTPResponseTests.swift
//  
//
//  Created by Mohanna Zakizadeh on 3/1/24.
//

import XCTest
import NetworkingInterface
@testable import Networking

final class HTTPResponseTests: XCTestCase {
    private let sampleJson = """
        {
            "id": "1",
            "name": "Mohanna",
            "appName": "SnapCanvas"
        }
    """
    private let corruptedJson = """
                {
                    "id": "1",
                }
    """
    private struct DummyModel: Decodable {
        let name: String
        let id: String
        let appName: String
    }
    
    private struct DummyRouter: NetworkingRouterProtocol {
        var method: HTTPMethod {
            .get
        }
        
        var path: String
        
        var headerFields: [String : String] = [:]
        
        init(path: String) {
            self.path = path
        }
    }
    
    private var mockHTTPClient: HTTPClient!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockHTTPClient = HTTPClient(configuration: configuration, baseURL: URL(string: "https://appostrophe.se")!)
    }
    
    func stubRequest(with data: Data, error: Error? = nil, url: URL, statusCode: Int, headerfields: [String: String]) {
        MockURLProtocol.error = error
        MockURLProtocol.requestHandler = { request in
            let response: HTTPURLResponse = HTTPURLResponse(url: url,
                                                            statusCode: statusCode,
                                                            httpVersion: nil,
                                                            headerFields: headerfields)!
            return (response, data)
        }
    }
    
    func testRawResponse() async throws {
        // given
        let data = sampleJson.data(using: .utf8)!
        stubRequest(with: data, url: URL(string: "path")!, statusCode: 200, headerfields: ["Content-Type": "application/json"])
        let dummyRouter: DummyRouter = DummyRouter(path: "path")
        
        let request = HTTPRequest(router: dummyRouter)
        // when
        let response = try await request.fetch(mockHTTPClient)
        // then
        XCTAssert(response.data == data)
    }
    
    func testSuccessResponseWithDecoding() async throws {
        // given
        let data = sampleJson.data(using: .utf8)!
        stubRequest(with: data, url: URL(string: "successResponsePath")!, statusCode: 200, headerfields: ["Content-Type": "application/json"])
        let dummyRouter: DummyRouter = DummyRouter(path: "successResponsePath")
        
        let request = HTTPRequest(router: dummyRouter)
        // when
        let decodedObject = try await mockHTTPClient.fetch(request).decode(DummyModel.self)
        // then
        XCTAssertEqual(decodedObject.id, "1")
        XCTAssert(decodedObject.name == "Mohanna")
    }
    
    func testConnectionErrorResponse() async {
        // given
        let data = sampleJson.data(using: .utf8)!
        stubRequest(with: data, error: URLError(URLError.Code.networkConnectionLost), url: URL(string: "ErrorPathURL")!, statusCode: 500, headerfields: ["Content-Type": "application/json"])
        let dummyRouter: DummyRouter = DummyRouter(path: "ErrorPathURL")
        
        let req = HTTPRequest(router: dummyRouter)
        // when
        // then
        await XCTAssertThrowsError(try await mockHTTPClient.fetch(req).decode(DummyModel.self)) { error in
            XCTAssertEqual(error as? HTTPResponseError, HTTPResponseError(.network))
        }
    }
    
    func testTimeoutErrorResponse() async {
        // given
        let data = sampleJson.data(using: .utf8)!
        stubRequest(with: data, error: URLError(URLError.Code.timedOut), url: URL(string: "timeoutPath")!, statusCode: 500, headerfields: ["Content-Type": "application/json"])
        let dummyRouter: DummyRouter = DummyRouter(path: "timeoutPath")
        
        let req = HTTPRequest(router: dummyRouter)
        // when
        // then
        await XCTAssertThrowsError(try await mockHTTPClient.fetch(req).decode(DummyModel.self)) { error in
            XCTAssertEqual(error as? HTTPResponseError, HTTPResponseError(.timeout))
        }
    }
    
    func testCorruptedJson() async {
        // given
        let data = corruptedJson.data(using: .utf8)!
        stubRequest(with: data, url: URL(string: "corruptedJson")!, statusCode: 200, headerfields: ["Content-Type": "application/json"])
        let dummyRouter: DummyRouter = DummyRouter(path: "corruptedJson")
        
        let request = HTTPRequest(router: dummyRouter)
        // when
        // then
        await XCTAssertThrowsError(try await mockHTTPClient.fetch(request).decode(DummyModel.self)) { error in
            XCTAssertEqual(error as? HTTPResponseError, HTTPResponseError(.objectDecodeFailed(message: "The given data was not valid JSON.")))
        }
    }

}

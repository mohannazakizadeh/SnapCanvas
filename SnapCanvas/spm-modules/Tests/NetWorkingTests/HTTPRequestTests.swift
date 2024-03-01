//
//  HTTPRequestTests.swift
//  
//
//  Created by Mohanna Zakizadeh on 3/1/24.
//

import XCTest
import NetworkingInterface
@testable import Networking

final class HTTPRequestTests: XCTestCase {
    
    private struct DummyRouter: NetworkingRouterProtocol {
        var method: HTTPMethod {
            .get
        }
        
        var path: String
        
        init(path: String) {
            self.path = path
        }
    }
    
    func testRequestBuilder() throws {
        // given
        let client = HTTPClient(baseURL: URL(string: "https://appostropheanalytics.herokuapp.com/scrl/test")!)
        let dummyRouter: DummyRouter = DummyRouter(path: "overlays")
        let request = HTTPRequest(router: dummyRouter)
        
        // when
        let urlRequest = try! request.urlRequest(inClient: client)
        
        // then
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://appostropheanalytics.herokuapp.com/scrl/test/overlays")
    }
}

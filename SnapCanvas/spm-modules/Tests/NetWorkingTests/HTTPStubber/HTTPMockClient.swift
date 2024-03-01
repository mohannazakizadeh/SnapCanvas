//
//  HTTPMockClient.swift
//
//
//  Created by Mohanna Zakizadeh on 3/1/24.
//

import Foundation
import Networking

final class HTTPMockClient {
    
    static let shared = HTTPMockClient()
    
    private init() {}
    
    lazy var mockClient: HTTPClient = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let client = HTTPClient(configuration: configuration, baseURL: URL(string: "BASEURL")!)
        return client
    }()
}

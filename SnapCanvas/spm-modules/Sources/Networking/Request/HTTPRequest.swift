//
//  HTTPRequest.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Combine
import Foundation
import NetworkingInterface

public class HTTPRequest: CustomStringConvertible {
    
    /// HTTP Method for request
    public var method: HTTPMethod
    
    /// Set the full absolute URL for the request by ignoring the the url components
    public var url: URL? {
        get {
            urlComponents.url
        }
        set {
            if let url = newValue,
               let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                urlComponents = components
            }
        }
    }
    
    /// URLRequest for this HTTPRequest property
    /// NOTE: This variable will be nil until you request to fetch from client
    public private(set) var urlRequest: URLRequest?
    
    /// Headers to send along the request.
    ///
    /// NOTE:
    /// Values here are combined with HTTPClient's values where the request is executed
    /// with precedence for request's keys.
    public var headers: [String: String] = [:]
    
    /// Description of the request
    public var description: String {
        "\(url?.absoluteString ?? "") [\(method)] "
    }
    
    // URLComponents of the network request.
    internal var urlComponents = URLComponents()
    
    // MARK: - Initialization
    
    required public init(router: NetworkingRouterProtocol) {
        self.method = router.method
        self.path = router.path
    }
    
    // MARK: - Fetch Operations
    
    /// Fetch data asynchronously and return the raw response.
    ///
    /// - Parameter client: client where execute the request.
    /// - Returns: `HTTPResponse`
    public func fetch(_ client: HTTPClient) async throws -> HTTPResponse {
        return try await client.fetch(self)
    }
}

// MARK: - HTTPRequest + URLComponents
public extension HTTPRequest {
    
    /// path component of the URL.
    ///
    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }
}

// MARK: - URLRequest Builders
public extension HTTPRequest {
    
    // MARK: - Internal Functions
    
    /// Create the `URLRequest` instance for a client instance.
    ///
    /// - Parameter client: client instance.
    /// - Returns: `URLRequest`
    func urlRequest(inClient client: HTTPClient?) throws -> URLRequest {
        
        guard let client = client, let url = urlComponents.fullURLInClient(client) else {
            throw HTTPResponseError(.internal)
        }
        
        let requestTimeout = client.timeout
        // adding additional headers to request header
        //  - client default headers
        //  - request's custom `headers` (this property)
        //  - optional headers set in body request
        let requestHeaders = client.defaultHeaders
            .merging(headers) { _, new in
                new
            }
        
        // Prepare the request
        var urlRequest = URLRequest(url: url,
                                        method: method,
                                        cachePolicy: .useProtocolCachePolicy,
                                        timeout: requestTimeout,
                                        headers: requestHeaders)
        urlRequest.httpShouldHandleCookies = true
        
        
        self.urlRequest = urlRequest
        
        return urlRequest
    }
}

extension URLComponents {
    
    mutating func fullURLInClient(_ client: HTTPClient?) -> URL? {
        guard host == nil else {
            return self.url
        }
        
        guard let baseURL = client?.baseURL else {
            return nil
        }
        
        // If we have not specified an absolute URL the URL
        // must be composed using the base components of the set client.
        var newComp = self
        newComp.scheme = baseURL.scheme
        newComp.host = baseURL.host
        newComp.port = baseURL.port
        newComp.path = baseURL.path + (newComp.path.first == "/" ? "" : "/") + newComp.path
        
        return newComp.url
    }
}

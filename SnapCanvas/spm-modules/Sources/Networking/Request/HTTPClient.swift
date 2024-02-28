//
//  HTTPClient.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Combine
import Foundation
import NetworkingInterface

/// HTTPClient is the place where each request will be executed.
public class HTTPClient: HTTPClientProtocol, CustomStringConvertible {
    
    // MARK: - Public Properties
    
    public var description: String {
        "[\(self.baseURL.absoluteString)]"
    }
    
    /// URLSessionConfigurastion used to perform request in this client.
    public var session: URLSession {
        loader.session
    }
    
    public var baseURL: URL
    
    /// Default Headers which are automatically attached to each request.
    public var defaultHeaders: [String : String] = ["Accept-Encoding": "gzip, deflate", "Accept": "application/json"]
    
    /// Timeout interval for requests,
    public var timeout: TimeInterval
    
    // MARK: - Private Properties
    
    /// Event monitor used to execute http requests.
    private var loader: HTTPDataLoader
    
    // MARK: - Initialization
    
    /// Initialize a new HTTP Client instance with a given configuration.
    ///
    /// - Parameters:
    ///   - baseURL: base URL. You can also pass a valid URL as `String`.
    ///   - maxConcurrentOperations: the number of concurrent network operation we can execute. If not specified is managed
    ///                              by the operation system and you don't need to set a value unless you have some other constraints.
    ///   - configuration: `URLSession` configuration. The available types are `default`,
    ///                    `ephemeral` and `background`, if you don't provide any or don't have
    ///                     special needs then Default will be used.
    ///
    ///                     - `default`: uses a persistent disk-based cache (except when the result is downloaded to a file)
    ///                     and stores credentials in the user’s keychain.
    ///                     It also stores cookies (by default) in the same shared cookie store as the
    ///                     NSURLConnection and NSURLDownload classes.
    ///                     - `ephemeral`: similar to a default session configuration object except that
    ///                     the corresponding session object does not store caches,
    ///                     credential stores, or any session-related data to disk. Instead,
    ///                     session-related data is stored in RAM.
    ///                     - `background`: suitable for transferring data files while the app runs in the background.
    ///                     A session configured with this object hands control of the transfers over to the system,
    ///                     which handles the transfers in a separate process.
    ///                     In iOS, this configuration makes it possible for transfers to continue even when
    ///                     the app itself is suspended or terminated.
    public init(maxConcurrentOperations: Int? = nil,
                configuration: URLSessionConfiguration = .ephemeral,
                baseURL: URL,
                networkLogger: HTTPLoggerProtocol? = nil,
                timeout: TimeInterval = 15)
    {
        self.timeout = timeout
        configuration.timeoutIntervalForRequest = timeout
        self.loader = HTTPDataLoader(configuration: configuration, maxConcurrentOperations: maxConcurrentOperations, networkLogger: networkLogger)
        self.baseURL = baseURL
        self.loader.client = self
    }
    
    // MARK: - Internal Functions
    
    /// Execute the request and return the promise.
    ///
    /// - Parameter request: request to execute in client.
    /// - Returns: `HTTPResponse`
    public func fetch(_ request: HTTPRequest) async throws -> HTTPResponse {
        try await loader.fetch(request)
    }
    
    public func fetchPublisher(_ request: HTTPRequest) -> AnyPublisher<HTTPResponse, HTTPResponseError> {
        loader.fetchRawResponsePublisher(request: request)
    }
}


//
//  HTTPDataLoader.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Combine
import Foundation
import NetworkingInterface

@available(iOS 15.0, *)
internal class HTTPDataLoader: NSObject, URLSessionTaskDelegate {
    
    // MARK: - Internal Properties
    
    /// URLSession instance which manage calls.
    internal var session: URLSession!
    
    /// Weak references to the parent HTTPClient instance.
    internal weak var client: HTTPClient?
    
    /// Operation queue.
    private var queue = OperationQueue()
    
    private var networkLogger: HTTPLoggerProtocol?
    
    // MARK: - Initialization
    
    /// Initialize a new client configuration.
    ///
    /// - Parameters:
    ///   - configuration: configuration setting.
    ///   - maxConcurrentOperations: number of concurrent operations.
    required init(configuration: URLSessionConfiguration, maxConcurrentOperations: Int? = nil, networkLogger: HTTPLoggerProtocol?) {
        super.init()
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: queue)
        self.networkLogger = networkLogger
        if let maxConcurrentOperations {
            self.queue.maxConcurrentOperationCount = maxConcurrentOperations
        }
    }
    
    // MARK: - Internal Function
    
    /// Perform fetch of the request in background and return the response asynchrously.
    ///
    /// - Parameter request: request to execute.
    /// - Returns: `HTTPResponse`
    func fetch(_ request: HTTPRequest) async throws -> HTTPResponse {
        guard let client = client else {
            fatalError("HTTP Client can't be nil")
        }
        let networkCallTimestamp: Date = Date()
        do {
            let urlRequest = try request.urlRequest(inClient: client)
            let (data, urlResponse) = try await session.data(for: urlRequest)
            let requestExecutionTime = Date().timeIntervalSince(networkCallTimestamp)
            let response = HTTPResponse(response: urlResponse, data: data)
            // network log
            Task.detached(priority: .background) {
                self.networkLogger?.log(for: request, response: response, error: nil, executionTime: requestExecutionTime)
            }
            return response
        } catch {
            let translatedError = HTTPResponseError.fromResponse(nil, error: error)
            let requestExecutionTime = Date().timeIntervalSince(networkCallTimestamp)
            // network log
            Task.detached(priority: .background) {
                self.networkLogger?.log(for: request, response: nil, error: translatedError ?? error, executionTime: requestExecutionTime)
            }
            throw translatedError ?? error
        }
    }
    
    // MARK: - Reactive Fetch Operations
    
    func fetchRawResponsePublisher(request: HTTPRequest) -> AnyPublisher<HTTPResponse, HTTPResponseError> {
        
        guard let client = client else {
            fatalError("HTTPClient can't be nil")
        }
        
        guard let urlRequest = try? request.urlRequest(inClient: client) else {
            return Fail(error: HTTPResponseError(.invalidURL))
                    .eraseToAnyPublisher()
        }
        let networkCallTimestamp: Date = Date()
        
        return client
            .session
            .dataTaskPublisher(for: urlRequest)
            .mapError({ urlError -> HTTPResponseError in
                return HTTPResponseError.fromResponse(nil, error: urlError) ?? .init(.network)
            })
            .tryMap({ data, response -> HTTPResponse in
                let httpResponse = HTTPResponse(response: response, data: data)
                if let httpResponseError = httpResponse.error {
                    throw httpResponseError
                }
                return httpResponse
            })
            .mapError({ error -> HTTPResponseError in
                if let httpResponseError = error as? HTTPResponseError {
                    return httpResponseError
                } else {
                    return HTTPResponseError(.internal)
                }
            })
            .eraseToAnyPublisher()
            .logRequest(request: request, logger: networkLogger, requestTime: networkCallTimestamp)
    }
}



//
//  URLRequests+Extension.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Foundation
import NetworkingInterface

extension URLRequest {
    
    // MARK: - Additional Initialization
    
    /// Create a new instance of `URLRequest` with passed settings.
    ///
    /// - Parameters:
    ///   - url: url convertible value.
    ///   - method: http method to use.
    ///   - timeout: timeout interval.
    ///   - headers: headers to use.
    public init(url: URL, method: HTTPMethod,
                cachePolicy: URLRequest.CachePolicy,
                timeout: TimeInterval,
                headers: [String: String]? = nil) {
        
        self.init(url: url)
        self.httpMethod = method.rawValue
        self.timeoutInterval = timeout
        self.allHTTPHeaderFields = headers
    }
}

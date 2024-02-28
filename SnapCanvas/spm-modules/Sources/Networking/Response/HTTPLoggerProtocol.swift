//
//  HTTPLoggerProtocol.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Foundation

public protocol HTTPLoggerProtocol {
    /// Use this function to debug network calls
    /// - Parameters:
    ///   - request: Request that executed
    ///   - response: Response from server
    ///   - error: Errors that might have thrown
    ///   - executionTime: Request executionTime
    func log(for request: HTTPRequest, response: HTTPResponse?, error: Error?, executionTime: TimeInterval)
}

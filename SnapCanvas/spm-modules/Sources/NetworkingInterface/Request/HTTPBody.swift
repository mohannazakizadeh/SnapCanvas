//
//  HTTPBody.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Foundation

// MARK: - HTTPBody
/// Defines the body of a request, including the content's body and additional headers.
public struct HTTPBody {
    
    // MARK: - Public Properties
    
    /// Content of the body.
    public var content: Data
    
    /// Additional headers to set.
    public var headers: [String: String]?
    
    /// URLEncoded params
    public var params: [URLQueryItem]?
    
    // MARK: - Initialization
    
    /// Initialize a new body.
    ///
    /// - Parameters:
    ///   - content: content of the body.
    ///   - headers: additional headers to set.
    public init(content: Data, headers: [String: String] = [:]) {
        self.content = content
        self.headers = headers
    }
    
    // MARK: - Static funcs
    
    public static func jsonBodyWithEncodableObject<T: Encodable>(object: T, keyEncodeStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) throws -> HTTPBody {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodeStrategy
        do {
            let encodedData = try encoder.encode(object)
            return HTTPBody(content: encodedData, headers: ["Content-Type": "application/json"])
        } catch {
            throw HTTPResponseError(.jsonEncodingFailed)
        }
    }
    
    public static func jsonBodyWithJsonObject(dict: [String: Any]) throws -> HTTPBody {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return HTTPBody(content: jsonData, headers: ["Content-Type": "application/json"])
        } catch {
            throw HTTPResponseError(.jsonEncodingFailed)
        }
    }
}


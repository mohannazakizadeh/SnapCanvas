//
//  HTTPResponseError.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Foundation

public struct HTTPResponseError: Error, LocalizedError, Equatable {
    
    public static func == (lhs: HTTPResponseError, rhs: HTTPResponseError) -> Bool {
        return lhs.category == rhs.category &&
        lhs.statusCode == rhs.statusCode
    }
    
    /// HTTP Status Code if available.
    public let statusCode: HTTPStatusCode
    
    /// Category of the error.
    public internal(set) var category: ErrorCategory

    public enum ErrorCategory: Equatable {
        case invalidURL
        case jsonEncodingFailed
        case urlEncodingFailed
        case invalidResponse
        case objectDecodeFailed(message: String)
        case network
        case notFound
        case customError(message: String)
        case custom(Error)
        case timeout
        case `internal`
        
        public static func == (lhs: HTTPResponseError.ErrorCategory, rhs: HTTPResponseError.ErrorCategory) -> Bool {
            return lhs.value == rhs.value
        }
        
        var value: String? {
            return String(describing: self).components(separatedBy: "(").first
        }
    }
    
    public init(_ type: ErrorCategory, message: String? = nil, code: HTTPStatusCode = .none) {
        self.category = type
        self.statusCode = code
    }
    
    public var errorDescription: String? {
        switch category {
        case .customError(let message):
            return message
        case .custom(let error):
            return error.localizedDescription
        case .objectDecodeFailed(let message):
            return message
        case .network:
            return "Network error, check your internet connection"
        default:
            return "Request failed, \(category)"
        }
    }
}

// MARK: - HTTPError (URLResponse)

extension HTTPResponseError {
    
    /// Parse the response of an HTTP operation and return `nil` if no error has found,
    /// a valid `HTTPResponseError` if call has failed.
    ///
    /// - Parameter httpResponse: response from http layer.
    /// - Returns: HTTPError?
    public static func fromResponse(_ response: URLResponse?, error: Error?) -> HTTPResponseError? {
        
        // if thrown error type is already a HTTPResponseError, ignoring then translation
        
        if let httpResponseError = error as? HTTPResponseError {
            return httpResponseError
        }
        
        if let response {
            // If HTTP is an error or an error has received we can create the error object
            let httpCode = HTTPStatusCode.fromResponse(response)
            let isError = (error != nil || httpCode.responseType != .success)
            
            guard isError else {
                return nil
            }
        } else {
            let tError = (error as NSError?)?.errorType ?? .network
            return HTTPResponseError(tError)
        }
        
        // Evaluate error kind
        let errorType: HTTPResponseError.ErrorCategory = (error as NSError?)?.errorType ?? .network
        
        return HTTPResponseError(errorType)
    }
    
}

// MARK: - Swift.Error

extension NSError {
    var errorType: HTTPResponseError.ErrorCategory {
        switch (domain, code) {
        case (NSURLErrorDomain, URLError.notConnectedToInternet.rawValue):
            return .network
        case (NSURLErrorDomain, URLError.networkConnectionLost.rawValue):
            return .network
        case (NSURLErrorDomain, URLError.cannotLoadFromNetwork.rawValue):
            return .network
        case (NSURLErrorDomain, URLError.dataNotAllowed.rawValue):
            return .network
        case (NSURLErrorDomain, URLError.timedOut.rawValue):
            return .timeout
        default:
            return .customError(message: self.localizedDescription)
        }
    }
}

// MARK: - DecodingError

extension DecodingError {
    /// Parse decoding error
    /// - Parameters:
    ///   - error: Decoding error generated while decoding object
    ///   - type: type that is used to decode with
    /// - Returns: Error message that occured while decoding
    public static func parseDecodeError(_ error: DecodingError, for type: String) -> String {
        var decodeErrorMessage: String = ""
        switch error {
        case .dataCorrupted(let context):
            decodeErrorMessage = "Failed parsing for type \(type) with error: \n\(context.debugDescription)"
        case .keyNotFound(let key, let context):
            decodeErrorMessage = "Key \(key) not found while parsing type \(type) with error: \n\(context.debugDescription)"
        case .typeMismatch(let subType, let context):
            decodeErrorMessage = "Sub type \(subType) mismatch for type \(type) with error: \n\(context.debugDescription)"
        case .valueNotFound(let subType, let context):
            decodeErrorMessage = "Value not forun for subtype \(subType) for type \(type) with error: \n\(context.debugDescription)"
        @unknown default:
            decodeErrorMessage = "Unknown type"
        }
        return decodeErrorMessage
    }
}

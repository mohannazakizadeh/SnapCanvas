//
//  HTTPResponse.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Foundation
import NetworkingInterface

// MARK: - HTTPResponse

/// This is the raw response received from server. It includes all the
/// data collected from the request including metrics and errors.
public class HTTPResponse {
    
    // MARK: - Public Properties
    
    /// `URLResponse` object received from server.
    public var urlResponse: URLResponse?
    
    /// Casted `HTTPURLResponse` object received from server.
    public var httpResponse: HTTPURLResponse? {
        urlResponse as? HTTPURLResponse
    }
    
    /// HTTP status code of the response, if available.
    public var statusCode: HTTPStatusCode
    
    /// Headers received into the response.
    public var headers: [String: String] {
        (httpResponse?.allHeaderFields as? [String: String]) ?? [:]
    }
    
    public var data: Data?
    
    /// Only works if the data is in json format
    public var prettyPrintedData: String {
        return data?.prettyPrintedJson ?? "Returned data is either empty or not in json format"
    }
    
    /// Error parsed.
    public var error: HTTPResponseError?
    
    /// Initialize with response from data loader.
    ///
    /// - Parameter response: URLResponse received in URLSessionTask
    /// - Parameter data: Data returned from server
    internal init(response: URLResponse, data: Data?, error: Error? = nil) {
        self.urlResponse = response
        self.data = data
        if let error {
            self.error = HTTPResponseError.fromResponse(response, error: error)
        }
        self.statusCode = HTTPStatusCode.fromResponse(response)
    }
    
    // MARK: - Decoding
    
    /// Decode a raw response using `Decodable` object type.
    ///
    /// - Returns: `T` or `nil` if no response has been received.
    public func decode<T: Decodable>(_ decodable: T.Type, decoder: JSONDecoder = .init()) throws -> T {
        
        if let error = error {
            throw error // dispatch any error coming from fetch outside the decode.
        }
        
        guard let data = data else {
            throw HTTPResponseError(.invalidResponse)
        }
        
        var decodeErrorMessage: String = ""
        let type = String(describing: T.self)
        
        do {
            let decodedObj = try decoder.decode(T.self, from: data)
            return decodedObj
        } catch {
            if let decodingError = error as? DecodingError {
                decodeErrorMessage = DecodingError.parseDecodeError(decodingError, for: type)
            } else {
                let type = String(describing: T.self)
                decodeErrorMessage = "Failed parsing for type \(type) with error: \(error.localizedDescription)"
            }
            throw HTTPResponseError(.objectDecodeFailed(message: decodeErrorMessage))
        }
    }
}

public extension Data {
    var prettyPrintedJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        
        return prettyPrintedString
    }
}

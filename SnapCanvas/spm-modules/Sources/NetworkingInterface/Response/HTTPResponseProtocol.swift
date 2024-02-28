//
//  HTTPResponseProtocol.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Foundation

//public protocol HTTPResponseProtocol {
//    /// `URLResponse` object received from server.
//    var urlResponse: URLResponse? { get set }
//    /// HTTP status code of the response, if available.
//    var statusCode: HTTPStatusCode { get set }
//    /// Headers received into the response.
//    var headers: [String: String] { get }
//    /// Response data
//    var data: Data? { get set }
//    /// Parsed error
//    var error: HTTPResponseError? { get set }
//    /// Decode a raw response using `Decodable` object type.
//    ///
//    /// - Returns: `T` or `nil` if no response has been received.
//    func decode<T: Decodable>(_ decodable: T.Type, decoder: JSONDecoder) throws -> T
//}

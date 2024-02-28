//
//  HTTPResponse+Combine.swift
//  
//
//  Created by Mohanna Zakizadeh on 2/23/24
//

import Combine
import Foundation
import NetworkingInterface

public extension AnyPublisher where Output == HTTPResponse, Failure == HTTPResponseError {
    func decodeDataPublisher<T: Decodable>(request: HTTPRequest, decoder: JSONDecoder = .init()) -> AnyPublisher<T, HTTPResponseError> {
        return self
            .compactMap(\.data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> HTTPResponseError in
                switch error {
                case let responseError as HTTPResponseError:
                    return responseError
                case let decodeError as DecodingError:
                    return HTTPResponseError(.objectDecodeFailed(message: DecodingError.parseDecodeError(decodeError, for: String(describing: T.self))))
                default:
                    return HTTPResponseError(.internal)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func logRequest(request: HTTPRequest, logger: HTTPLoggerProtocol?, requestTime: Date) -> AnyPublisher<HTTPResponse, HTTPResponseError> {
        let requestExecutionTime = Date().timeIntervalSince(requestTime)
        
        return self
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Task.detached(priority: .background) {
                        logger?.log(for: request, response: nil, error: error, executionTime: requestExecutionTime)
                    }
                case .finished:
                    break
                }
            })
            .handleEvents(receiveOutput: { response in
                Task.detached(priority: .background) {
                    logger?.log(for: request, response: response, error: nil, executionTime: requestExecutionTime)
                }
            })
            .eraseToAnyPublisher()
    }
}


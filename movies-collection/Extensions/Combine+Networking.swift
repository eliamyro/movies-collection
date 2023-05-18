//
//  Combine+Networking.swift
//  movies-collection
//
//  Created by Elias Myronidis on 17/5/23.
//

import Combine
import Foundation

public extension Publisher where Output == (data: Data, response: URLResponse) {
    func assumeHTTP() -> AnyPublisher<(data: Data, response: HTTPURLResponse), RequestError> {
        tryMap { (data: Data, response: URLResponse) in
            guard let http = response as? HTTPURLResponse else { throw RequestError.nonHTTPResponse }
            return (data, http)
        }
        .mapError { error in
            if error is RequestError {
                return error as! RequestError
            } else {
                return RequestError.networkError(error: error)
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where
    Output == (data: Data, response: HTTPURLResponse),
    Failure == RequestError {

    func responseData() -> AnyPublisher<Data, RequestError> {
        tryMap { (data: Data, response: HTTPURLResponse) -> Data in
            switch response.statusCode {
            case 200...299: return data
            default:
                throw RequestError.invalidResponse
            }
        }
        .mapError { $0 as! RequestError }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == Data, Failure == RequestError {
    func decoding<T: Decodable, Decoder: TopLevelDecoder>(_ type: T.Type, decoder: Decoder) -> AnyPublisher<T, RequestError> where Decoder.Input == Data {
        decode(type: T.self, decoder: decoder)
            .mapError { error in
                if error is DecodingError {
                    return RequestError.decodingError(error: error as! DecodingError)
                } else {
                    return error as! RequestError
                }
            }
            .eraseToAnyPublisher()
    }
}

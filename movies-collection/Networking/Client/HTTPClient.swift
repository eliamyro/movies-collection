//
//  HTTPClient.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Combine
import UIKit

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseType: T.Type) -> AnyPublisher<T, RequestError>

    func downloadImage(endpoint: Endpoint) -> AnyPublisher<UIImage?, Never>
    func downloadImage(endpoint: Endpoint, completed: @escaping (UIImage?) -> Void)
}

class HTTPClientImp: HTTPClient {
    let cacheManager = CacheManager.shared

    func sendRequest<T: Decodable>(endpoint: Endpoint, responseType: T.Type) -> AnyPublisher<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            print("Failed to get url from urlComponents")
            return Fail(error: RequestError.invalidURL).eraseToAnyPublisher()
        }

        print("URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header // Try also without it

        return URLSession.shared.dataTaskPublisher(for: request)
            .assumeHTTP()
            .responseData()
            .decoding(T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func downloadImage(endpoint: Endpoint) -> AnyPublisher<UIImage?, Never> {
        let cacheKey = NSString(string: endpoint.path)

        if let image = cacheManager.object(for: cacheKey) {
            return Just(image).eraseToAnyPublisher()
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path

        guard let url = urlComponents.url else {
            print("Failed to get url from urlComponents")
            return Just(nil).eraseToAnyPublisher()
        }

        print("URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { [weak self] data, response in
                guard let self = self, let gResponse = response as? HTTPURLResponse,
                      gResponse.statusCode >= 200 && gResponse.statusCode < 300,
                      let image = UIImage(data: data) else {
                    return nil
                }

                self.cacheManager.addToCache(image, for: cacheKey)
                return image
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }

    func downloadImage(endpoint: Endpoint, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: endpoint.path)

        if let image = cacheManager.object(for: cacheKey) {
            completed(image)
            return
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path

        guard let url = urlComponents.url else {
            print("Failed to get url from urlComponents")
            return completed(nil)
        }

        print("URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                completed(nil)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil)
                return
            }

            guard let data = data else {
                completed(nil)
                return
            }

            if let image = UIImage(data: data) {
                self?.cacheManager.addToCache(image, for: cacheKey)
                completed(image)
            }
        }

        task.resume()
    }
}

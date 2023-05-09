//
//  HTTPClient.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import UIKit

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completed: @escaping (Result<T, RequestError>) -> Void)
    func downloadImage(endpoint: Endpoint, completed: @escaping (UIImage?) -> Void)
}

class HTTPClientImp: HTTPClient {
    static let shared = HTTPClientImp()

    let cache = NSCache<NSString, UIImage>()

    func sendRequest<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completed: @escaping (Result<T, RequestError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            print("Failed to get url from urlComponents")
            return completed(.failure(.invalidURL))
        }

        print("URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header // Try also without it

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completed(.failure(.unableToComplete(error: error)))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completed(.success(response))
            } catch {
                completed(.failure(.decodingError(error: error)))
            }
        }

        task.resume()
    }

    func downloadImage(endpoint: Endpoint, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: endpoint.path)

        if let image = cache.object(forKey: cacheKey) {
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
                self?.cache.setObject(image, forKey: cacheKey)
                completed(image)
            }
        }

        task.resume()
    }
}

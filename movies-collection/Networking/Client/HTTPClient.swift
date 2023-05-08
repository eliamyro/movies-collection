//
//  HTTPClient.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseType: T.Type)
}

class HTTPClientImp: HTTPClient {
    func sendRequest<T>(endpoint: Endpoint, responseType: T.Type) where T: Decodable {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            print("Failed to get url from urlComponents")
            return
        }

        print("URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header // Try also without it

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(APIMoviesResponse.self, from: data)

                if let movies = response.results {
                    for movie in movies {
                        print(movie.title ?? "")
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }

        task.resume()
    }
}

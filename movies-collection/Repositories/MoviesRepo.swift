//
//  MoviesRepo.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Combine
import UIKit

protocol MoviesRepo {
    func fetchPopularMovies<T: Decodable>(page: Int) -> AnyPublisher<T, RequestError>
    func fetchMedia<T: Decodable>(query: String, page: Int) -> AnyPublisher<T, RequestError>
    func fetchDetails<T: Decodable>(id: Int, mediaType: String) -> AnyPublisher<T, RequestError>
    func fetchVideos<T: Decodable>(id: Int, mediaType: String) -> AnyPublisher<T, RequestError>

    func downloadImage(imageUrl: String) -> AnyPublisher<UIImage?, Never>
    func downloadImage(imageUrl: String, completed: @escaping ((UIImage?) -> Void))

    func fetchCredits<T: Decodable>(id: Int, mediaType: String) -> AnyPublisher<T, RequestError>
    func deleteFavoriteMediaFromDb(id: Int) -> AnyPublisher<Bool, Never>
    func saveFavoriteMediaToDb(media: APIMovie) -> AnyPublisher<Bool, Never>
}

class MoviesRepoImp: MoviesRepo {
    @Injected var httpClient: HTTPClient

    func fetchPopularMovies<T: Decodable>(page: Int) -> AnyPublisher<T, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.popularMovies(page: page), responseType: T.self)
    }
 
    func fetchMedia<T: Decodable>(query: String, page: Int) -> AnyPublisher<T, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.multiSearch(query: query, page: page), responseType: T.self)
    }

    func fetchDetails<T: Decodable>(id: Int, mediaType: String) -> AnyPublisher<T, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaDetails(id: id, mediaType: mediaType), responseType: T.self)
    }

    func fetchVideos<T: Decodable>(id: Int, mediaType: String) -> AnyPublisher<T, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaVideos(id: id, mediaType: mediaType), responseType: T.self)
    }

    func downloadImage(imageUrl: String) -> AnyPublisher<UIImage?, Never> {
        httpClient.downloadImage(endpoint: MoviesEndpoint.downloadImage(imageUrl: imageUrl))
    }
    func downloadImage(imageUrl: String, completed: @escaping ((UIImage?) -> Void)) {
        httpClient.downloadImage(endpoint: MoviesEndpoint.downloadImage(imageUrl: imageUrl), completed: completed)
    }

    func fetchCredits<T: Decodable>(id: Int, mediaType: String) -> AnyPublisher<T, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaCredits(id: id, mediaType: mediaType), responseType: T.self)
    }

    func deleteFavoriteMediaFromDb(id: Int) -> AnyPublisher<Bool, Never> {
        CoreDataManager.shared.deleteFavoriteMedia(id: id)
    }

    func saveFavoriteMediaToDb(media: APIMovie) -> AnyPublisher<Bool, Never> {
        CoreDataManager.shared.saveFavoriteMedia(media: media)
    }
}

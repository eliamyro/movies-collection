//
//  MoviesRepo.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Combine
import UIKit

protocol MoviesRepo {
    func fetchPopularMovies(page: Int) -> AnyPublisher<APIMoviesResponse, RequestError>
    func fetchMedia(query: String, page: Int) -> AnyPublisher<APIMoviesResponse, RequestError>
    func fetchDetails(id: Int, mediaType: String) -> AnyPublisher<APIDetails, RequestError>
    func fetchVideos(id: Int, mediaType: String) -> AnyPublisher<APIVideosResponse, RequestError>
    func downloadImage(imageUrl: String) -> AnyPublisher<UIImage?, Never>
    func fetchCredits(id: Int, mediaType: String) -> AnyPublisher<APICreditsResponse, RequestError>
    func deleteFavoriteMediaFromDb(id: Int) -> AnyPublisher<Bool, Never>
    func saveFavoriteMediaToDb(media: APIMovie) -> AnyPublisher<Bool, Never>
}

class MoviesRepoImp: MoviesRepo {
    @Injected var httpClient: HTTPClient

    func fetchPopularMovies(page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.popularMovies(page: page), responseType: APIMoviesResponse.self)
    }
 
    func fetchMedia(query: String, page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.multiSearch(query: query, page: page), responseType: APIMoviesResponse.self)
    }

    func fetchDetails(id: Int, mediaType: String) -> AnyPublisher<APIDetails, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaDetails(id: id, mediaType: mediaType), responseType: APIDetails.self)
    }

    func fetchVideos(id: Int, mediaType: String) -> AnyPublisher<APIVideosResponse, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaVideos(id: id, mediaType: mediaType), responseType: APIVideosResponse.self)
    }

    func downloadImage(imageUrl: String) -> AnyPublisher<UIImage?, Never> {
        httpClient.downloadImage(endpoint: MoviesEndpoint.downloadImage(imageUrl: imageUrl))
    }

    func fetchCredits(id: Int, mediaType: String) -> AnyPublisher<APICreditsResponse, RequestError> {
        httpClient.sendRequest(endpoint: MoviesEndpoint.mediaCredits(id: id, mediaType: mediaType), responseType: APICreditsResponse.self)
    }

    func deleteFavoriteMediaFromDb(id: Int) -> AnyPublisher<Bool, Never> {
        CoreDataManager.shared.deleteFavoriteMedia(id: id)
    }

    func saveFavoriteMediaToDb(media: APIMovie) -> AnyPublisher<Bool, Never> {
        CoreDataManager.shared.saveFavoriteMedia(media: media)
    }
}

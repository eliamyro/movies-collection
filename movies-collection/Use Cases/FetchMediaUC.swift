//
//  FetchMediaUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 9/5/23.
//

import Combine
import Foundation

protocol FetchMediaUC {
    func execute(query: String, page: Int) -> AnyPublisher<APIMoviesResponse, RequestError>
}

class FetchMediaUCImp: FetchMediaUC {

    @Injected var repo: MoviesRepo

    func execute(query: String, page: Int) -> AnyPublisher<APIMoviesResponse, RequestError> {
        repo.fetchMedia(query: query, page: page)
    }
}

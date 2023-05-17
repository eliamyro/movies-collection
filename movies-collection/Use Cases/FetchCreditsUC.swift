//
//  FetchCreditsUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 12/5/23.
//

import Combine
import Foundation

protocol FetchCreditsUC {
    func execute(id: Int, mediaType: String) -> AnyPublisher<APICreditsResponse, RequestError>
    func execute(id: Int, mediaType: String, completed: @escaping (Result<APICreditsResponse, RequestError>) -> Void)
}

class FetchCreditsUCImp: FetchCreditsUC {
    @Injected var repo: MoviesRepo

    func execute(id: Int, mediaType: String) -> AnyPublisher<APICreditsResponse, RequestError> {
        repo.fetchCredits(id: id, mediaType: mediaType)
    }
    func execute(id: Int, mediaType: String, completed: @escaping (Result<APICreditsResponse, RequestError>) -> Void) {
        repo.fetchCredits(id: id, mediaType: mediaType, completed: completed)
    }
}

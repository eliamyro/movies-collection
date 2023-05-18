//
//  FetchVideosUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Combine
import Foundation

protocol FetchVideosUC {
    func execute(id: Int, mediaType: String) -> AnyPublisher<APIVideosResponse, RequestError>
}

class FetchVideosUCImp: FetchVideosUC {
    @Injected var repo: MoviesRepo

    func execute(id: Int, mediaType: String) -> AnyPublisher<APIVideosResponse, RequestError> {
        repo.fetchVideos(id: id, mediaType: mediaType)
    }
}

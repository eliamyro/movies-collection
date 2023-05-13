//
//  FetchVideosUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Foundation

protocol FetchVideosUC {
    func execute(id: Int, mediaType: String, completed: @escaping (Result<APIVideosResponse, RequestError>) -> Void)
}

class FetchVideosUCImp: FetchVideosUC {
    @Injected var repo: MoviesRepo

    func execute(id: Int, mediaType: String, completed: @escaping (Result<APIVideosResponse, RequestError>) -> Void) {
        repo.fetchVideos(id: id, mediaType: mediaType, completed: completed)
    }
}

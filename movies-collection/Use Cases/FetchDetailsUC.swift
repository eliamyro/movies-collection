//
//  FetchDetailsUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Foundation

protocol FetchDetailsUC {
    func execute(id: Int, mediaType: String, completed: @escaping (Result<APIDetails, RequestError>) -> Void)
}

class FetchDetailsUCImp: FetchDetailsUC {
    @Injected var repo: MoviesRepo

    func execute(id: Int, mediaType: String, completed: @escaping (Result<APIDetails, RequestError>) -> Void) {
        repo.fetchDetails(id: id, mediaType: mediaType, completed: completed)
    }
}

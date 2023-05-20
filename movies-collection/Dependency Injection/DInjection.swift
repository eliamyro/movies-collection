//
//  DInjection.swift
//  movies-collection
//
//  Created by Elias Myronidis on 13/5/23.
//

import Foundation

class DIInitializer {
    static func setup() {
        DInjection.shared = DInjection()
    }
}

class DInjection: DependencyContainer {
    static var shared = DependencyContainer()

    init(empty: Bool = false) {
        super.init()

        if !empty { registerDependencies() }
    }

    func registerDependencies() {
        registerSources()
        registerRepositories()
        registerUseCases()
    }

    private func registerSources() {
        register(HTTPClient.self) { HTTPClientImp() }
    }

    private func registerRepositories() {
        register(MoviesRepo.self) { MoviesRepoImp() }
    }

    private func registerUseCases() {
        register(FetchPopularMoviesUC.self) { FetchPopularMoviesUCImp() }
        register(FetchMediaUC.self) { FetchMediaUCImp() }
        register(DownloadImageUC.self) { DownloadImageUCImp() }
        register(FetchDetailsUC.self) { FetchDetailsUCImp() }
        register(FetchVideosUC.self) { FetchVideosUCImp() }
        register(FetchCreditsUC.self) { FetchCreditsUCImp() }
        register(DeleteFavoriteMediaFromDbUC.self) { DeleteFavoriteMediaFromDbUCImp() }
        register(SaveFavoriteMediaToDbUC.self) { SaveFavoriteMediaToDbUCImp() }
    }
}

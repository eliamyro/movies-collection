//
//  DInjection.swift
//  movies-collection
//
//  Created by Elias Myronidis on 13/5/23.
//

import Foundation

class DInjection {
    static let shared = DInjection()

    private init() {}

    func registerDependencies() {
        registerSources()
        registerRepositories()
        registerUseCases()
    }

    private func registerSources() {
        DependencyContainer.shared.register(HTTPClient.self) { HTTPClientImp() }
    }
    
    private func registerRepositories() {
        DependencyContainer.shared.register(MoviesRepo.self) { MoviesRepoImp() }
    }
    
    private func registerUseCases() {
        DependencyContainer.shared.register(FetchPopularMoviesUC.self) { FetchPopularMoviesUCImp() }
        DependencyContainer.shared.register(FetchMediaUC.self) { FetchMediaUCImp() }
        DependencyContainer.shared.register(DownloadImageUC.self) { DownloadImageUCImp() }
        DependencyContainer.shared.register(FetchDetailsUC.self) { FetchDetailsUCImp() }
        DependencyContainer.shared.register(FetchVideosUC.self) { FetchVideosUCImp() }
        DependencyContainer.shared.register(FetchCreditsUC.self) { FetchCreditsUCImp() }

    }
}

//
//  MoviesListVM.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Combine
import Foundation

class MoviesListVM {
    @Injected var fetchPopularMoviesUC: FetchPopularMoviesUC
    @Injected var fetchMediaUC: FetchMediaUC
    @Injected var deleteFavoriteMediaFromDbUC: DeleteFavoriteMediaFromDbUC
    @Injected var saveFavoriteMediaToDbUC: SaveFavoriteMediaToDbUC

    var page = 1
    var query = ""
    var isScrolling = false

    @Published var apiMovies: [APIMovie] = []
    var loaderSubject = CurrentValueSubject<Bool, Never>(false)
    var favoriteTappedSubject = PassthroughSubject<IndexPath, Never>()
    var cancellables = Set<AnyCancellable>()

    func fetchPopularMovies() {
        loaderSubject.send(true)
        fetchPopularMoviesUC.execute(page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                self?.loaderSubject.send(false)
                print(error.description)
            } receiveValue: { [weak self] moviesResponse in
                guard let self = self else { return }
                self.loaderSubject.send(false)
                self.apiMovies.append(contentsOf: moviesResponse.results ?? [])
            }
            .store(in: &cancellables)
    }

    func fetchMedia() {
        loaderSubject.send(true)
        fetchMediaUC.execute(query: query, page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case .failure(let error) = completion else { return }
                self?.loaderSubject.send(false)
                print(error.description)
            } receiveValue: { [weak self] moviesResponse in
                guard let self = self else { return }
                self.loaderSubject.send(false)
                let media = self.filterMoviesAndShows(media: moviesResponse.results ?? [])
                self.apiMovies.append(contentsOf: media)
            }
            .store(in: &cancellables)
    }

    private func filterMoviesAndShows(media: [APIMovie]) -> [APIMovie] {
        return media.filter { return $0.mediaType == "movie" || $0.mediaType == "tv"}
    }

    func search() {
        if !isScrolling {
            initializeProperties()
        }

        if query.isEmpty {
            fetchPopularMovies()
        } else {
            fetchMedia()
        }
    }

    func initializeProperties() {
        page = 1
        apiMovies = []
    }

    func updateFavoriteAndReload(indexPath: IndexPath) {
        let isFavorite = apiMovies[indexPath.row].isFavorite

        if isFavorite {
            // Delete from db
            let id = apiMovies[indexPath.row].id ?? 0
            deleteFavoriteMediaFromDbUC.execute(id: id)
                .sink { [weak self] completed in
                    guard let self = self else { return }
                    if completed {
                        self.favoriteTappedSubject.send(indexPath)
                    }
                }.store(in: &cancellables)
        } else {
            // Save to db
            let media = apiMovies[indexPath.row]
            saveFavoriteMediaToDbUC.execute(media: media)
                .sink { [weak self] completed in
                    guard let self = self else { return }
                    if completed {
                        self.favoriteTappedSubject.send(indexPath)
                    }
                }
                .store(in: &cancellables)
        }
    }
}

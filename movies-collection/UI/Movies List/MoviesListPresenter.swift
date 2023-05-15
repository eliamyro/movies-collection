//
//  MoviesListPresenter.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

protocol MoviesListDelegate: AnyObject {
    func updateMoviesList()
    func reloadRows(indexPath: IndexPath)
    func showLoader()
    func hideLoader()
}

class MoviesListPresenter {

    @Injected var fetchPopularMoviesUC: FetchPopularMoviesUC
    @Injected var fetchMediaUC: FetchMediaUC
    @Injected var deleteFavoriteMediaFromDbUC: DeleteFavoriteMediaFromDbUC
    @Injected var saveFavoriteMediaToDbUC: SaveFavoriteMediaToDbUC

    weak var delegate: MoviesListDelegate?
    var page = 1
    var query = ""
    var movies: [APIMovie] = []
    var isScrolling = false

    func setViewDelegate(delegate: MoviesListDelegate?) {
        self.delegate = delegate
    }

    func fetchPopularMovies() {
        print("fetchPopularMovies")
        delegate?.showLoader()
        fetchPopularMoviesUC.execute(page: page) { [weak self] result in

            switch result {
            case .success(let moviesResponse):
                DispatchQueue.main.async {
                    self?.movies.append(contentsOf: moviesResponse.results ?? [])
                    self?.delegate?.hideLoader()
                    self?.delegate?.updateMoviesList()
                }
            case .failure(let error):
                self?.delegate?.hideLoader()
                print(error.description)
            }
        }
    }

    func fetchMedia() {
        print("fetchMedia")
        delegate?.showLoader()
        fetchMediaUC.execute(query: query, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moviesResponse):
                DispatchQueue.main.async {
                    let media = self.filterMoviesAndShows(media: moviesResponse.results ?? [])
                    self.movies.append(contentsOf: media)
                    self.delegate?.hideLoader()
                    self.delegate?.updateMoviesList()
                }
            case .failure(let error):
                self.delegate?.hideLoader()
                print(error.description)
            }
        }
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
        movies = []
    }

    func updateFavoriteAndReload(indexPath: IndexPath) {
        let isFavorite = movies[indexPath.row].isFavorite

        if isFavorite {
            // Delete from db
            let id = movies[indexPath.row].id ?? 0
            deleteFavoriteMediaFromDbUC.execute(id: id) { [weak self] completed in
                guard let self = self else { return }
                if completed {
                    self.delegate?.reloadRows(indexPath: indexPath)
                }
            }
        } else {
            // Save to db
            let media = movies[indexPath.row]
            saveFavoriteMediaToDbUC.execute(media: media) { [weak self] completed in
                guard let self = self else { return }
                if completed {
                    self.delegate?.reloadRows(indexPath: indexPath)
                }
            }
        }
    }
}

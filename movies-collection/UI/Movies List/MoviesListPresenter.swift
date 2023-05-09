//
//  MoviesListPresenter.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

protocol MoviesListDelegate: AnyObject {
    func updateMoviesList()
    func showLoader()
    func hideLoader()
}
class MoviesListPresenter {

    let fetchPopularMoviesUC = FetchPopularMoviesUCImp()
    weak var delegate: MoviesListDelegate?
    var page = 1
    var movies: [APIMovie] = []

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
}

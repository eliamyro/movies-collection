//
//  MoviesListVM.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

class MoviesListVM {

    let fetchPopularMoviesUC = FetchPopularMoviesUCImp()

    func fetchPopularMovies() {
        print("fetchPopularMovies")
        fetchPopularMoviesUC.execute()
    }
}

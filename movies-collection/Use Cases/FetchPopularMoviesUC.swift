//
//  FetchPopularMoviesUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 8/5/23.
//

import Foundation

protocol FetchPopularMoviesUC {
    func execute()
}

class FetchPopularMoviesUCImp: FetchPopularMoviesUC {
    let repo = MoviesRepoImp()

    func execute() {
        print("FetchPopularMoviesUCImp")
        repo.fetchPopularMovies()
    }
}

//
//  SaveFavoriteMediaToDbUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 15/5/23.
//

import Foundation

protocol SaveFavoriteMediaToDbUC {
    func execute(media: APIMovie, completed: @escaping (Bool) -> Void)
}

class SaveFavoriteMediaToDbUCImp: SaveFavoriteMediaToDbUC {
    @Injected var repo: MoviesRepo

    func execute(media: APIMovie, completed: @escaping (Bool) -> Void) {
        repo.saveFavoriteMediaToDb(media: media, completed: completed)
    }
}

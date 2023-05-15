//
//  DeleteFavoriteMediaFromDBUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 15/5/23.
//

import Foundation

protocol DeleteFavoriteMediaFromDbUC {
    func execute(id: Int, completed: @escaping (Bool) -> Void)
}

class DeleteFavoriteMediaFromDbUCImp: DeleteFavoriteMediaFromDbUC {
    @Injected var repo: MoviesRepo

    func execute(id: Int, completed: @escaping (Bool) -> Void) {
        repo.deleteFavoriteMediaFromDb(id: id, completed: completed)
    }
}

//
//  DeleteFavoriteMediaFromDBUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 15/5/23.
//

import Combine
import Foundation

protocol DeleteFavoriteMediaFromDbUC {
    func execute(id: Int) -> AnyPublisher<Bool, Never>
}

class DeleteFavoriteMediaFromDbUCImp: DeleteFavoriteMediaFromDbUC {
    @Injected var repo: MoviesRepo

    func execute(id: Int) -> AnyPublisher<Bool, Never> {
        repo.deleteFavoriteMediaFromDb(id: id)
    }
}

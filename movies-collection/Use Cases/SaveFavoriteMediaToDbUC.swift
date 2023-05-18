//
//  SaveFavoriteMediaToDbUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 15/5/23.
//

import Combine
import Foundation

protocol SaveFavoriteMediaToDbUC {
    func execute(media: APIMovie) -> AnyPublisher<Bool, Never>
}

class SaveFavoriteMediaToDbUCImp: SaveFavoriteMediaToDbUC {
    @Injected var repo: MoviesRepo

    func execute(media: APIMovie) -> AnyPublisher<Bool, Never> {
        repo.saveFavoriteMediaToDb(media: media)
    }
}

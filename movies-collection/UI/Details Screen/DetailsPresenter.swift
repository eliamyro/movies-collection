//
//  DetailsPresenter.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Foundation

protocol DetailsDelegate: AnyObject {

}

class DetailsPresenter {
    let fetchDetailsUC = FetchDetailsUCImp()
    weak var delegate: MoviesListDelegate?
    var movie: APIMovie?

    func setViewDelegate(delegate: MoviesListDelegate?) {
        self.delegate = delegate
    }

    func fetchDetails() {
        let mediaType = movie?.getMediaType ?? ""
        fetchDetailsUC.execute(id: movie?.id ?? 0, mediaType: mediaType) { result in
            switch result {
            case .success(let media):
                print("Media: \(media.title ?? media.name ?? "")")

            case .failure(let error):
                print(error.description)
            }
        }
    }
}

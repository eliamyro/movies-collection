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
    let fetchVideosUC = FetchVideosUCImp()
    weak var delegate: MoviesListDelegate?
    var movie: APIMovie?
    var mediaType: String {
        movie?.getMediaType ?? ""
    }

    let dispatchGroup = DispatchGroup()
    var mediaDetails: APIDetails?
    var mediaVideo: APIVideo?

    func setViewDelegate(delegate: MoviesListDelegate?) {
        self.delegate = delegate
    }

    func fetchData() {
        fetchDetails()
        fetchVideos()

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            print("Finished: \(self.mediaDetails?.id ?? 0), \(self.mediaVideo?.key ?? "")")
        }
    }

    func fetchDetails() {
        dispatchGroup.enter()
        fetchDetailsUC.execute(id: movie?.id ?? 0, mediaType: mediaType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let media):
                print("Media: \(media.title ?? media.name ?? "")")
                self.mediaDetails = media
                self.dispatchGroup.leave()

            case .failure(let error):
                print(error.description)
                self.dispatchGroup.leave()
            }
        }
    }

    func fetchVideos() {
        dispatchGroup.enter()
        fetchVideosUC.execute(id: movie?.id ?? 0, mediaType: mediaType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let videos = response.results ?? []
                self.mediaVideo = videos.first
                self.dispatchGroup.leave()

            case .failure(let error):
                print(error.description)
                self.dispatchGroup.leave()
            }
        }
    }
}

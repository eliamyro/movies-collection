//
//  DetailsPresenter.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Foundation
import UIKit

protocol DetailsDelegate: AnyObject {
    func updateData()
    func showLoader()
    func hideLoader()
    func updateFavoriteButton(image: UIImage?)
}

class DetailsPresenter {
    @Injected var fetchDetailsUC: FetchDetailsUC
    @Injected var fetchVideosUC: FetchVideosUC
    @Injected var fetchCreditstUC: FetchCreditsUC
    @Injected var deleteFavoriteMediaFromDbUC: DeleteFavoriteMediaFromDbUC
    @Injected var saveFavoriteMediaToDbUC: SaveFavoriteMediaToDbUC

    weak var delegate: DetailsDelegate?
    var movie: APIMovie?
    var indexPath: IndexPath?

    var mediaType: String {
        movie?.getMediaType ?? ""
    }

    var elements: [CustomElementModel] = []

    let dispatchGroup = DispatchGroup()
    var mediaDetails: APIDetails?
    var mediaVideo: APIVideo?
    var cast: [CastModel]?

    func setViewDelegate(delegate: DetailsDelegate?) {
        self.delegate = delegate
    }

    func fetchData() {
        delegate?.showLoader()
        fetchDetails()
        fetchCredits()
        fetchVideos()

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.elements.append(PosterModel(mediaDetails: self.mediaDetails))
            self.elements.append(DetailsInfoModel(mediaDetails: self.mediaDetails))

            if let key = self.mediaVideo?.key {
                self.elements.append(TrailerModel(trailerKey: key))
            }
            
            self.elements.append(CollectionViewContainerModel(collectionItems: self.cast ?? []))

            self.delegate?.updateData()
            self.delegate?.hideLoader()
        }
    }

    func fetchDetails() {
        dispatchGroup.enter()
        fetchDetailsUC.execute(id: movie?.id ?? 0, mediaType: mediaType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let media):
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

    func fetchCredits() {
        dispatchGroup.enter()

        fetchCreditstUC.execute(id: movie?.id ?? 0, mediaType: mediaType) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.cast = response.castModels
                self.dispatchGroup.leave()

            case .failure(let error):
                print(error.description)
                self.dispatchGroup.leave()
            }
        }
    }

    func updateFavorite(isFavorite: Bool) {
        guard let media = movie else { return }
        if isFavorite {
            // Delete from db
            let id = media.id ?? 0
            deleteFavoriteMediaFromDbUC.execute(id: id) { [weak self] completed in
                guard let self = self else { return }
                if completed {
                    self.delegate?.updateFavoriteButton(image: self.favoriteImage())
                }
            }
        } else {
            // Save to db
            saveFavoriteMediaToDbUC.execute(media: media) { [weak self] completed in
                guard let self = self else { return }
                if completed {
                    self.delegate?.updateFavoriteButton(image: self.favoriteImage())
                }
            }
        }
    }

    func favoriteImage() -> UIImage? {
        return movie?.isFavorite ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
}

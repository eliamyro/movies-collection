//
//  DetailsVM.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Combine
import Foundation
import UIKit

class DetailsVM {
    @Injected var fetchDetailsUC: FetchDetailsUC
    @Injected var fetchVideosUC: FetchVideosUC
    @Injected var fetchCreditstUC: FetchCreditsUC
    @Injected var deleteFavoriteMediaFromDbUC: DeleteFavoriteMediaFromDbUC
    @Injected var saveFavoriteMediaToDbUC: SaveFavoriteMediaToDbUC

    var movie: APIMovie?
    var indexPath: IndexPath?

    var mediaType: String {
        movie?.getMediaType ?? ""
    }

    @Published var apiElements: [CustomElementModel] = []
    @Published var apiMediaDetails: APIDetails?
    @Published var apiCast: [CastModel]?
    @Published var apiVideo: APIVideo?
    var loaderSubject = CurrentValueSubject<Bool, Never>(false)
    var favoriteImageSubject = PassthroughSubject<UIImage?, Never>()
    var favoriteTappedSubject = PassthroughSubject<IndexPath?, Never>()

    var cancellables = Set<AnyCancellable>()

    func fetchData() {
        loaderSubject.send(true)

        Publishers.CombineLatest3(fetchDetails(), fetchCredits(), fetchVideos())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                guard case .failure(let error) = completion else { return }
                
                self.loaderSubject.send(false)
                print(error.description)
            } receiveValue: { [weak self] details, credits, videos in
                guard let self = self else { return }
                self.loaderSubject.send(false)

                self.apiElements.append(PosterModel(mediaDetails: details))
                self.apiElements.append(DetailsInfoModel(mediaDetails: details))

                let apiVideo = (videos.results ?? []).first
                if let key = apiVideo?.key {
                    self.apiElements.append(TrailerModel(trailerKey: key))
                }

                self.apiElements.append(CollectionViewContainerModel(collectionItems: credits.castModels))
            }
            .store(in: &cancellables)
    }

    func fetchDetails() -> AnyPublisher<APIDetails, RequestError> {
        fetchDetailsUC.execute(id: movie?.id ?? 0, mediaType: mediaType)
    }

    func fetchVideos() -> AnyPublisher<APIVideosResponse, RequestError> {
        fetchVideosUC.execute(id: movie?.id ?? 0, mediaType: mediaType)
    }

    func fetchCredits() -> AnyPublisher<APICreditsResponse, RequestError> {
        fetchCreditstUC.execute(id: movie?.id ?? 0, mediaType: mediaType)
    }

    func updateFavorite(isFavorite: Bool) {
        guard let media = movie else { return }
        if isFavorite {
            // Delete from db
            let id = media.id ?? 0
            deleteFavoriteMediaFromDbUC.execute(id: id)
                .sink { [weak self] completed in
                    guard let self = self else { return }
                    if completed {
                        self.favoriteImageSubject.send(self.favoriteImage())
                    }
                }
                .store(in: &cancellables)

        } else {
            // Save to db
            saveFavoriteMediaToDbUC.execute(media: media)
                .sink { [weak self] completed in
                    guard let self = self else { return }
                    if completed {
                        self.favoriteImageSubject.send(self.favoriteImage())
                    }
                }
                .store(in: &cancellables)
        }
    }

    func favoriteImage() -> UIImage? {
        return movie?.isFavorite ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
}

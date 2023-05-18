//
//  DownloadImageUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 10/5/23.
//

import Combine
import Foundation
import UIKit

protocol DownloadImageUC {
    func execute(imageUrl: String) -> AnyPublisher<UIImage?, Never>
    func execute(imageUrl: String, completed: @escaping ((UIImage?) -> Void))
}

class DownloadImageUCImp: DownloadImageUC {

    @Injected var repo: MoviesRepo

    func execute(imageUrl: String) -> AnyPublisher<UIImage?, Never> {
        repo.downloadImage(imageUrl: imageUrl)
    }
    func execute(imageUrl: String, completed: @escaping ((UIImage?) -> Void)) {
        repo.downloadImage(imageUrl: imageUrl, completed: completed)
    }
}

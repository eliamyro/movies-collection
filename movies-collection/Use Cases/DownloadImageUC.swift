//
//  DownloadImageUC.swift
//  movies-collection
//
//  Created by Elias Myronidis on 10/5/23.
//

import Foundation
import UIKit

protocol DownloadImageUC {
    func execute(imageUrl: String, completed: @escaping ((UIImage?) -> Void))
}

class DownloadImageUCImp: DownloadImageUC {

    let repo = MoviesRepoImp()

    func execute(imageUrl: String, completed: @escaping ((UIImage?) -> Void)) {
        repo.downloadImage(imageUrl: imageUrl, completed: completed)
    }
}

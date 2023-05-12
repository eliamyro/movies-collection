//
//  PosterModel.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Foundation

class PosterModel: CustomElementModel {
    var type: CustomElementType { return .poster }
    var mediaDetails: APIDetails?

    init(mediaDetails: APIDetails?) {
        self.mediaDetails = mediaDetails
    }
}

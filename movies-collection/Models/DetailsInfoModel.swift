//
//  DetailsInfoModel.swift
//  movies-collection
//
//  Created by Elias Myronidis on 12/5/23.
//

import Foundation

class DetailsInfoModel: CustomElementModel {
    var type: CustomElementType { return .detailsInfo }
    var mediaDetails: APIDetails?

    init(mediaDetails: APIDetails?) {
        self.mediaDetails = mediaDetails
    }
}

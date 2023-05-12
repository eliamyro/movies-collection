//
//  TrailerModel.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Foundation

class TrailerModel: CustomElementModel {
    var type: CustomElementType { return .trailer }
    var trailerKey: String

    init(trailerKey: String) {
        self.trailerKey = trailerKey
    }
}

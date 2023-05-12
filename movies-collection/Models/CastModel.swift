//
//  CastModel.swift
//  movies-collection
//
//  Created by Elias Myronidis on 12/5/23.
//

import Foundation

class CastModel: CustomElementModel {
    var type: CustomElementType { return .cast }
    var cast: APICast?

    init(cast: APICast?) {
        self.cast = cast
    }
}

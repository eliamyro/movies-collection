//
//  CollectionViewContainerModel.swift
//  movies-collection
//
//  Created by Elias Myronidis on 12/5/23.
//

import Foundation

class CollectionViewContainerModel: CustomElementModel {
    var type: CustomElementType { return .collectionViewContainer }
    var collectionItems: [CustomElementModel]

    init(collectionItems: [CustomElementModel]) {
        self.collectionItems = collectionItems
    }
}

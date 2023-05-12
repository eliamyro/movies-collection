//
//  CustomElementType.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Foundation

protocol CustomElementModel: AnyObject {
    var type: CustomElementType { get }
}

protocol CustomElementCell: AnyObject {
    func configure(with elementModel: CustomElementModel)
}

enum CustomElementType: String {
    case poster
    case trailer
    case detailsInfo
    case collectionViewContainer
    case cast
}

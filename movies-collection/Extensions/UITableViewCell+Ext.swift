//
//  UITableViewCell+Ext.swift
//  movies-collection
//
//  Created by Elias Myronidis on 9/5/23.
//

import UIKit

extension UITableViewCell {
    static var id: String {
        return String(describing: self)
    }
}

//
//  MainViewController.swift
//  movies-collection
//
//  Created by Elias Myronidis on 6/5/23.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .systemRed
        navigationItem.title = "Movies Collection"
    }
}

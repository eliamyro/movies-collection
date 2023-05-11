//
//  DetailsViewController.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Variables

    var presenter = DetailsPresenter()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        presenter.fetchDetails()
    }

    // MARK: - Setup UI

    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        let mediaTitle = presenter.movie?.title ?? presenter.movie?.name
        navigationItem.title = mediaTitle
    }
}

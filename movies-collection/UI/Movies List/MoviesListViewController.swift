//
//  MoviesListViewController.swift
//  movies-collection
//
//  Created by Elias Myronidis on 6/5/23.
//

import UIKit

class MoviesListViewController: UIViewController {

    // MARK: - Variables

    private var searchTask: Task<Void, Error>?
    
    private var presenter = MoviesListPresenter()

    // MARK: - Views

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator
    }()

    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something"

        return search
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.id)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(delegate: self)

        setupNavigationBar()
        setupTableView()
        setupIndicatorView()
        fetchPopularMovies()
    }

    // MARK: - Setup UI
    
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("movies_title", comment: "")
        navigationItem.searchController = searchController
    }

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupIndicatorView() {
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Helper methods

    private func fetchPopularMovies() {
        presenter.fetchPopularMovies()
    }

    private func updateFavoriteAndReload(indexPath: IndexPath) {
        let isFavorite = presenter.movies[indexPath.row].isFavorite
        presenter.movies[indexPath.row].isFavorite = !isFavorite
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UISearchResultsUpdating

extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.query = searchController.searchBar.text ?? ""

        searchTask?.cancel()

        searchTask = Task { @MainActor in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            presenter.isScrolling = false
            presenter.search()
        }
    }
}

extension MoviesListViewController: MoviesListDelegate {
    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    func updateMoviesList() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.id, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        cell.delegate = self
        cell.setup(movie: presenter.movies[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        let movie = presenter.movies[indexPath.row]
        let detailsController = DetailsViewController()
        detailsController.delegate = self
        detailsController.presenter.movie = movie
        detailsController.presenter.indexPath = indexPath
        navigationController?.pushViewController(detailsController, animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        if offsetY > (contentHeight - height) {
            presenter.isScrolling = true
            presenter.page += 1
            presenter.search()
            print("Page \(presenter.page)")
        }
    }
}

// MARK: - MovieCellDelegate

extension MoviesListViewController: MovieCellDelegate {
    func favoriteTapped(cell: MovieCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        updateFavoriteAndReload(indexPath: indexPath)
    }
}

extension MoviesListViewController: DetailsViewDelegate {
    func detailsFavoriteTapped(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        updateFavoriteAndReload(indexPath: indexPath)
    }
}

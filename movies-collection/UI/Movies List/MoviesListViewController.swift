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
    
    private var viewModel: MoviesListVM

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

    init(viewModel: MoviesListVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()

        setupNavigationBar()
        setupTableView()
        setupIndicatorView()

        viewModel.fetchPopularMovies()
    }

    private func bind() {
        viewModel.loaderSubject.sink { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        .store(in: &viewModel.cancellables)

        viewModel.$apiMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &viewModel.cancellables)

        viewModel.favoriteTappedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            .store(in: &viewModel.cancellables)
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
}

// MARK: - UISearchResultsUpdating

extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.query = searchController.searchBar.text ?? ""

        searchTask?.cancel()

        searchTask = Task { @MainActor in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            viewModel.isScrolling = false
            viewModel.search()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.apiMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.id, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        cell.favoriteSubject.sink { [weak self] favCell in
            guard let indexPath = tableView.indexPath(for: favCell) else { return }
            self?.viewModel.updateFavoriteAndReload(indexPath: indexPath)
        }.store(in: &cell.cancellables)

        cell.setup(movie: viewModel.apiMovies[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        let movie = viewModel.apiMovies[indexPath.row]
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
            viewModel.isScrolling = true
            viewModel.page += 1
            viewModel.search()
            print("Page \(viewModel.page)")
        }
    }
}

extension MoviesListViewController: DetailsViewDelegate {
    func detailsFavoriteTapped(indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

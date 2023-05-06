//
//  MainViewController.swift
//  movies-collection
//
//  Created by Elias Myronidis on 6/5/23.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Variables

    private var searchTask: Task<Void, Error>?
    private var movies = ["Hello", "Goodnight", "Thessaloniki", "Titanic", "Programmer"]

    // MARK: - Views

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupNavigationBar()
        setupTableView()
    }

    // MARK: - Setup UI
    
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Movies Collection"
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
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""

        searchTask?.cancel()

        searchTask = Task { @MainActor in
            try await Task.sleep(nanoseconds: 1_500_000_000)
            if text.isEmpty && text.count < 3 {
                print("Load movies")
            } else {
                print("Load series")
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = movies[indexPath.row]

        return cell
    }
}

//
//  DetailsViewController.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import Combine
import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Variables

    var viewModel: DetailsVM

    // MARK: - Views

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator
    }()

    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(dismissDetails), for: .touchUpInside)
        return button
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - Lifecycle

    init(viewModel: DetailsVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        bind()

        registerCells()
        viewModel.fetchData()
    }

    private func bind() {
        viewModel.loaderSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }

                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &viewModel.cancellables)

        viewModel.$apiElements
            .receive(on: DispatchQueue.main)
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                print(error)
            } receiveValue: { _ in
                self.tableView.reloadData()
            }
            .store(in: &viewModel.cancellables)

        viewModel.favoriteImageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.favoriteButton.setBackgroundImage(image, for: .normal)
                self.viewModel.favoriteTappedSubject.send(self.viewModel.indexPath)
            }
            .store(in: &viewModel.cancellables)
    }

    // MARK: - Setup UI

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func registerCells() {
        tableView.register(PosterCell.self, forCellReuseIdentifier: CustomElementType.poster.rawValue)
        tableView.register(DetailsInfoCell.self, forCellReuseIdentifier: CustomElementType.detailsInfo.rawValue)
        tableView.register(TrailerCell.self, forCellReuseIdentifier: CustomElementType.trailer.rawValue)
        tableView.register(CollectionViewContainerCell.self, forCellReuseIdentifier: CustomElementType.collectionViewContainer.rawValue)
    }

    private func setupUI() {
        setupTableView()
        setupBackButton()
        configureFavoriteButton()
        configureActivityIndicator()
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

    private func setupBackButton() {
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            backButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func configureFavoriteButton() {
        favoriteButton.setBackgroundImage(viewModel.favoriteImage(), for: .normal)
        view.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func dismissDetails() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func favoriteTapped() {
        print("Details favorite")
        let isFavorite = viewModel.movie?.isFavorite ?? false
        viewModel.updateFavorite(isFavorite: isFavorite)
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.apiElements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.apiElements[indexPath.row]
        let cellIdentifier = cellModel.type.rawValue
        print(cellIdentifier)
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                as? CustomElementCell else { return  UITableViewCell() }

        customCell.configure(with: cellModel)
        onLayoutChangeNeeded()
        return customCell as! UITableViewCell
    }

    func onLayoutChangeNeeded() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

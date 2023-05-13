//
//  MovieCell.swift
//  movies-collection
//
//  Created by Elias Myronidis on 6/5/23.
//

import UIKit

class MovieCell: UITableViewCell {

    // MARK: - Variables
    @Injected var downloadImageUC: DownloadImageUC

    // MARK: - Views
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.90
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "24 March 2023"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.text = "7.53"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.text = "From 2500 users"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set data

    func setup(movie: APIMovie) {
        downloadImageUC.execute(imageUrl: movie.backdropPath ?? "") { [weak self] image in
            DispatchQueue.main.async {
                self?.movieImage.image = image ?? UIImage(named: "tmdb")
            }
        }
        titleLabel.text = movie.getMediaType == "tv" ? movie.name : movie.title
        releaseDateLabel.text = movie.getMediaType == "tv" ? movie.firstAirDate : movie.releaseDate
        voteAverageLabel.text = "Rate: \(movie.voteAverage ?? 0)"
        voteCountLabel.text = "From \(movie.voteCount ?? 0) users"
    }
}

// MARK: - Setup UI
extension MovieCell {
    func configureUI() {
        configureContainerView()
        configureMovieImage()
        configureTitleLabel()
        configureReleaseDateLabel()
        configureVoteAverageLabel()
        configureVoteCountLabel()
    }

    func configureContainerView() {
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    func configureMovieImage() {
        containerView.addSubview(movieImage)

        let heightConstraint = movieImage.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            heightConstraint,
            movieImage.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    func configureTitleLabel() {
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }

    func configureReleaseDateLabel() {
        containerView.addSubview(releaseDateLabel)

        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    func configureVoteAverageLabel() {
        containerView.addSubview(voteAverageLabel)

        NSLayoutConstraint.activate([
            voteAverageLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 4),
            voteAverageLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 8),
            voteAverageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
        ])
    }

    func configureVoteCountLabel() {
        containerView.addSubview(voteCountLabel)

        NSLayoutConstraint.activate([
            voteCountLabel.leadingAnchor.constraint(equalTo: voteAverageLabel.trailingAnchor, constant: 8),
            voteCountLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            voteCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -8)
        ])
    }
}

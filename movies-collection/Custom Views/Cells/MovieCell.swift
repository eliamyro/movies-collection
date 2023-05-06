//
//  MovieCell.swift
//  movies-collection
//
//  Created by Elias Myronidis on 6/5/23.
//

import UIKit

class MovieCell: UITableViewCell {

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
        let image = UIImage(named: "titanic")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie title"
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.90
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

    // MARK: - Setup UI
    
    private func configureUI() {
        configureContainerView()
        configureMovieImage()
        configureTitleLabel()
    }

    private func configureContainerView() {
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    private func configureMovieImage() {
        containerView.addSubview(movieImage)

        let heightConstraint = movieImage.heightAnchor.constraint(equalToConstant: 150)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            heightConstraint,
            movieImage.widthAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
}

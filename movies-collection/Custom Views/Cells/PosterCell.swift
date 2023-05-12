//
//  PosterCell.swift
//  movies-collection
//
//  Created by Elias Myronidis on 11/5/23.
//

import UIKit

class PosterCell: UITableViewCell, CustomElementCell {

    // MARK: - Views

    private lazy var posterImageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var titleContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .blue.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with elementModel: CustomElementModel) {
        guard let model = elementModel as? PosterModel else {
            print("Unable to cast model as PosterModel")
            return
        }

        configureUI()
        setup(model: model)
    }

    private func setup(model: PosterModel) {
        guard let details = model.mediaDetails else { return }
        let downloadImageUC = DownloadImageUCImp()

        downloadImageUC.execute(imageUrl: details.posterUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }

        titleLabel.text = details.mediaTitle
    }
}

// MARK: - Setup Constraints

extension PosterCell {
    func configureUI() {
        configurePosterImageView()
        configureTitleContainerView()
        configureTitleLabel()
    }

    private func configurePosterImageView() {
        contentView.addSubview(posterImageView)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 300)

        ])
    }

    private func configureTitleContainerView() {
        posterImageView.addSubview(titleContainerView)

        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor)
        ])
    }

    private func configureTitleLabel() {
        titleContainerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: -8),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -8)
        ])
    }
}

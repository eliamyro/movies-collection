//
//  CastCollectionViewCell.swift
//  movies-collection
//
//  Created by Elias Myronidis on 12/5/23.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell, CustomElementCell {

    // MARK: - Views

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2.withAlphaComponent(0.3)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello how are you?"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    func configure(with elementModel: CustomElementModel) {
        guard let model = elementModel as? CastModel else {
            print("Unable to cast model as CastModel")
            return
        }

        configureUI()
        setup(model: model)
    }
    func setup(model: CastModel) {
        titleLabel.text = model.cast?.name ?? ""
    }
}

// MARK: - Setup Constraints

extension CastCollectionViewCell {
    func configureUI() {
        configureContainerView()
        configureTitleLabel()
    }

    private func configureContainerView() {
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    private func configureTitleLabel() {
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4)
        ])
    }
}

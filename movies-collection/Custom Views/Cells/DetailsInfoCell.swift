//
//  DetailsInfoCell.swift
//  movies-collection
//
//  Created by Elias Myronidis on 12/5/23.
//

import UIKit

class DetailsInfoCell: UITableViewCell, CustomElementCell {

    // MARK: - Views

    private lazy var genreLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var summaryLabel: UILabel = {
        var label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
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
        guard let model = elementModel as? DetailsInfoModel else {
            print("Unable to cast model as DetailsInfoModel")
            return
        }

        configureUI()
        setup(model: model)
    }

    private func setup(model: DetailsInfoModel) {
        guard let details = model.mediaDetails else { return }
        genreLabel.text = details.genre
        summaryLabel.text = details.summary
    }
}

// MARK: Setup Constraints

extension DetailsInfoCell {
    func configureUI() {
        configureGenreLabel()
        configureSummaryLabel()
    }

    private func configureGenreLabel() {
        contentView.addSubview(genreLabel)

        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    private func configureSummaryLabel() {
        contentView.addSubview(summaryLabel)

        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}

//
//  CollectionViewContainerCell.swift
//  movies-collection
//
//  Created by Elias Myronidis on 12/5/23.
//

import UIKit

class CollectionViewContainerCell: UITableViewCell, CustomElementCell {

    // MARK: - Variables

    var items: [CustomElementModel] = []

    // MARK: - Views
    
    lazy var collectionView: UICollectionView = {
        let colView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colView.translatesAutoresizingMaskIntoConstraints = false
        colView.dataSource = self
        colView.delegate = self

        let flowLayout = colView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.scrollDirection = .horizontal
        colView.showsHorizontalScrollIndicator = true

        return colView
    }()

    func configure(with elementModel: CustomElementModel) {
        guard let model = elementModel as? CollectionViewContainerModel else {
            print("Unable to cast model as CollectionViewContainerModel")
            return
        }

        configureUI()
        setup(model: model)
    }

    private func setup(model: CollectionViewContainerModel) {
        items = model.collectionItems
        collectionView.reloadData()
    }
}

// MARK: - Setup Constraints

extension CollectionViewContainerCell {
    func configureUI() {
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CustomElementType.cast.rawValue)

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

extension CollectionViewContainerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = items[indexPath.item]
        let cellIdentifier = cellModel.type.rawValue
        print(cellIdentifier)
        guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                as? CustomElementCell else { return  UICollectionViewCell() }

        customCell.configure(with: cellModel)
        return customCell as! UICollectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

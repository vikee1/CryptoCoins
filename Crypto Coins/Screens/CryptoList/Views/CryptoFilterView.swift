//
//  CryptoFilterView.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 13/11/24.
//

import UIKit

class CryptoFilterView: UIView {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var onCryptoFilterChange: (([Int]) -> Void)?
    private var viewMode: CryptoListViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupTableViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupTableViewConstraints()
    }

    private func setupView() {
        self.backgroundColor = .gray
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        collectionView.register(CryptoFilterCollectionViewCell.self, forCellWithReuseIdentifier: CryptoFilterCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8)
        ])
    }
    
    func configure(with viewModel: CryptoListViewModel) {
        self.viewMode = viewModel
        collectionView.reloadData()
    }
}

extension CryptoFilterView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewMode?.filters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoFilterCollectionViewCell.identifier, for: indexPath) as? CryptoFilterCollectionViewCell else { return UICollectionViewCell() }
        if let viewMode {
            let selected = viewMode.isIndexSelected(index: indexPath.item)
            cell.configure(with: viewMode.getFilterOption(index: indexPath.item).rawValue, selected: selected)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 * 4
        let availableWidth = collectionView.frame.width - padding
        let cellWidth = availableWidth / 3
        return CGSize(width: cellWidth, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelection(with: indexPath)
    }
    
    func updateSelection(with indexPath: IndexPath) {
        self.viewMode?.filterCryptos(index: indexPath.item)
        collectionView.reloadData()
    }
}

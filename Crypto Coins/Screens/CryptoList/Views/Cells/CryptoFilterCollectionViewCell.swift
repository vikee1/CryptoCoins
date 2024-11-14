//
//  CryptoFilterCollectionViewCell.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 13/11/24.
//

import UIKit

class CryptoFilterCollectionViewCell: UICollectionViewCell {
    static let identifier = "CryptoFilterCollectionViewCell"
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(lblTitle)
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            lblTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            lblTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            lblTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func configure(with title: String, selected: Bool) {
        self.contentView.backgroundColor = selected ? .lightGray : .white
        self.lblTitle.text = title
    }
}

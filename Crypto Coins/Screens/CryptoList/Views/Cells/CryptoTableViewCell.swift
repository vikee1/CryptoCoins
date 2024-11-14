//
//  CryptoTableViewCell.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 13/11/24.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    static let identifier = "CryptoTableViewCell"
    
    private lazy var imgType: UIImageView = {setupImage()}()
    
    private lazy var imgNew: UIImageView = {setupImage()}()
    
    private lazy var lblName: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .preferredFont(forTextStyle: .headline)
        return lable
    }()
    
    private lazy var lblSymbol: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .preferredFont(forTextStyle: .subheadline)
        return lable
    }()
    
    private lazy var stackLbls: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lblName, lblSymbol])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    private func setupImage() -> UIImageView {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }
    
    private func setupUI() {
        addSubview(imgNew)
        addSubview(imgType)
        addSubview(stackLbls)
        setupViewsConstraints()
    }
    
    private func setupViewsConstraints() {
        NSLayoutConstraint.activate([
            imgNew.trailingAnchor.constraint(equalTo: trailingAnchor),
            imgNew.topAnchor.constraint(equalTo: topAnchor),
            imgNew.widthAnchor.constraint(equalToConstant: 20),
            imgNew.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            imgType.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imgType.centerYAnchor.constraint(equalTo: centerYAnchor),
            imgType.widthAnchor.constraint(equalToConstant: 34),
            imgType.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            stackLbls.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackLbls.trailingAnchor.constraint(equalTo: imgType.leadingAnchor, constant: 8),
            stackLbls.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackLbls.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with crypto: CryptoTableCellData) {
        DispatchQueue.main.async {
            self.lblName.text = crypto.name
            self.lblSymbol.text = crypto.symbol
            let imageName = !crypto.isActive ? "inactive" : crypto.type.rawValue
            self.imgType.image = UIImage(named: imageName)
            let image = crypto.isNew ? UIImage(named: "new") : nil
            self.imgNew.image = image
        }
    }
}


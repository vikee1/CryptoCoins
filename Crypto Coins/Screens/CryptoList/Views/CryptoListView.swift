//
//  CryptoListView.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 13/11/24.
//

import UIKit

class CryptoListView: UIView {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.delegate = self
        searchbar.placeholder = "Search coins name and symbol"
        return searchbar
    }()
    
    private weak var viewModel: CryptoListViewModel?
    
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
    
    func configure(with viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        reloadTableView()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    private func setupView() {
        addSubview(searchBar)
        addSubview(tableView)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit(_:)))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func tapEdit(_ gesture: UITapGestureRecognizer) {
        searchBar.endEditing(true)
    }
}

extension CryptoListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.searchCryptos(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension CryptoListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.filteredCryptos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier) as? CryptoTableViewCell else { return UITableViewCell() }
        if let viewModel {
            cell.configure(with: viewModel.cryptoTableCellData(index: indexPath.row))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 66 }
}

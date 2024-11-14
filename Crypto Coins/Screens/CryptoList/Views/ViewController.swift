//
//  ViewController.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 12/11/24.
//

import UIKit

class ViewController: UIViewController {
    lazy var cryptoListView: CryptoListView = {
        let cryptolistview = CryptoListView()
        cryptolistview.translatesAutoresizingMaskIntoConstraints = false
        return cryptolistview
    }()
    
    lazy var filterView: CryptoFilterView = {
        let filterview = CryptoFilterView()
        filterview.translatesAutoresizingMaskIntoConstraints = false
        return filterview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configureView()
    }
    
    func setUpView() {
        view.backgroundColor = .white
        view.addSubview(cryptoListView)
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            filterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 120)
            ])
        
        NSLayoutConstraint.activate([
            cryptoListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cryptoListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cryptoListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cryptoListView.bottomAnchor.constraint(equalTo: filterView.topAnchor)
            ])
    }
    
    func configureView(with viewModel: CryptoListViewModel = CryptoListViewModel()) {
        self.cryptoListView.configure(with: viewModel)
        self.filterView.configure(with: viewModel)
        viewModel.delegate = self
    }

}

extension ViewController: CryptoListViewModelActionsProtocol {
    func onCryptoListUpdated() {
        self.cryptoListView.reloadTableView()
    }
}


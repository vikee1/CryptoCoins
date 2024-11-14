//
//  CryptoListViewModel.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 12/11/24.
//

import Foundation

typealias CryptoTableCellData = (name: String, symbol: String, isNew: Bool, isActive: Bool, type: TypeEnum)

protocol CryptoListViewModelProtocol {
    func isIndexSelected(index: Int) -> Bool
    func getFilterOption(index: Int) -> CryptoFilter
    func cryptoTableCellData(index: Int) -> CryptoTableCellData
    func fetchCryptoList()
    func filterCryptos(index: Int)
    func filterCryptosWithSelectedOptions()
    func filterCryptos(isActive: Bool?, type: String?, isNew: Bool?)
    func searchCryptos(query: String)
}

protocol CryptoListViewModelActionsProtocol: AnyObject {
    func onCryptoListUpdated()
}

enum CryptoFilter: String, CaseIterable {
    case ActiveCoins = "Active Coins"
    case InactiveCoins = "Inactive Coins"
    case OnlyTokens = "Only Tokens"
    case OnlyCoins = "Only Coins"
    case NewCoins = "New Coins"
}

class CryptoListViewModel: CryptoListViewModelProtocol {
        
    private let networkManager: NetworkManagerProtocol
    private(set) var cryptos: [Crypto] = []
    private(set) var filteredCryptos: [Crypto] = []
    private(set) var filters = CryptoFilter.allCases
    private(set) var selectedIndexs: [CryptoFilter] = []
    private var savedCryptosKey: String = "Saved Cryptos"
    
    weak var delegate: CryptoListViewModelActionsProtocol?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        fetchCryptoList()
    }
    
    func isIndexSelected(index: Int) -> Bool {
        selectedIndexs.contains(filters[index])
    }
    
    func getFilterOption(index: Int) -> CryptoFilter { filters[index] }
    
    func cryptoTableCellData(index: Int) -> CryptoTableCellData {
        let model = filteredCryptos[index]
        return (name: model.name, symbol: model.symbol, isNew: model.isNew, isActive: model.isActive, type: model.type)
    }
    
    func fetchCryptoList() {
        let url = ApiUtility.CoinList.coins.url
        let resource = Resource<[Crypto]>(url: url, httpMethod: .get)
        networkManager.sendRequest(resource: resource, sessionConfig: .default) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cryptos):
                self.saveOrFetchCryptos(cryptos: cryptos, error: nil)
            case .failure(let error, _):
                self.saveOrFetchCryptos(cryptos: nil, error: error)
                debugPrint("Error fetching data: \(error)")
            }
        }
    }
    
    func saveOrFetchCryptos(cryptos: [Crypto]?, error: CustomErrors?) {
        var savedCryptos: [Crypto] = []
        if let error, error == .noInternet {
            savedCryptos = fetchSavedCryptos() ?? []
        } else if let cryptos {
            savedCryptos = cryptos
            AppUtility.saveEncodeData(value: savedCryptos, for: savedCryptosKey)
        }
        self.cryptos = savedCryptos
        self.filteredCryptos = savedCryptos
        self.delegate?.onCryptoListUpdated()
    }
    
    func fetchSavedCryptos() -> [Crypto]? {
        return AppUtility.fetchDecodeData(for: savedCryptosKey)
    }
    
    func filterCryptos(index: Int) {
        let cryptoFilter = filters[index]
        if let index = selectedIndexs.firstIndex(of: cryptoFilter) {
            selectedIndexs.remove(at: index)
        } else {
            selectedIndexs.append(cryptoFilter)
        }
        filterCryptosWithSelectedOptions()
    }
    
    func filterCryptosWithSelectedOptions() {
        let hasActiveCoins = selectedIndexs.contains(.ActiveCoins)
        let hasInactiveCoins = selectedIndexs.contains(.InactiveCoins)
        let hasOnlyCoins = selectedIndexs.contains(.OnlyCoins)
        let hasOnlyTokens = selectedIndexs.contains(.OnlyTokens)
        let hasNewCoins = selectedIndexs.contains(.NewCoins)
        
        let isActive: Bool? = hasActiveCoins && hasInactiveCoins ? nil : hasActiveCoins ? true : hasInactiveCoins ? false : nil
        let type: String? = hasOnlyCoins && hasOnlyTokens ? nil : hasOnlyCoins ? "coin" : hasOnlyTokens ? "token" : nil
        let isNew = hasNewCoins ? true : nil
        
        filterCryptos(isActive: isActive, type: type, isNew: isNew)

    }
    
    func filterCryptos(isActive: Bool?, type: String?, isNew: Bool?) {
        filteredCryptos = cryptos.filter { crypto in
            let matchesActive = isActive == nil || crypto.isActive == isActive
            let matchesType = type == nil || crypto.type.rawValue == type
            let matchesNew = isNew == nil || crypto.isNew == isNew
            return matchesActive && matchesType && matchesNew
        }
        delegate?.onCryptoListUpdated()
    }
    
    func searchCryptos(query: String) {
        if query.isEmpty {
            filterCryptosWithSelectedOptions()
            return
        }
        filteredCryptos = cryptos.filter { crypto in
            crypto.name.lowercased().contains(query.lowercased()) ||
            crypto.symbol.lowercased().contains(query.lowercased())
        }
        delegate?.onCryptoListUpdated()
    }
    
}


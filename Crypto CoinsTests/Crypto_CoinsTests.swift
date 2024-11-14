//
//  Crypto_CoinsTests.swift
//  Crypto CoinsTests
//
//  Created by Vikee's Macbook Air on 12/11/24.
//
import Testing
@testable import Crypto_Coins
import Foundation
import XCTest

struct Crypto_CoinsTests {
    var viewModel: CryptoListViewModel?
    var networkManager: NetworkManagerProtocol?
    
    init() async throws {
        networkManager = MockNetworkManager()
        viewModel = CryptoListViewModel(networkManager: networkManager!)
    }
    
    @Test func test_fetchCryptoList() {
        viewModel?.fetchCryptoList()
        XCTAssertNotNil(viewModel?.cryptos, "Crypto list should not be nil")
        XCTAssertEqual(viewModel?.filteredCryptos.count, 2, "Crypto list should have 3 items")
    }
    
    @Test func test_filterCryptos() {
        viewModel?.filterCryptos(index: 0)
        #expect(viewModel?.filters.count == 5, "Selected Crypto list should have 5 items")
        #expect(viewModel?.selectedIndexs.count == 1, "Selected Crypto list should have 1 items")
        #expect(viewModel?.filteredCryptos.count == 2, "Filterd Crypto list should have 2 items")
        #expect(viewModel?.filteredCryptos.first?.isActive == true, "isActive should be true")
    }
    
    @Test func test_getFilterOption() {
        let result = viewModel?.getFilterOption(index: 4)
        #expect(result?.rawValue == "New Coins", "Result value should be New Coins")
    }
    
    @Test func test_cryptoTableCellData() {
        let cellData = viewModel?.cryptoTableCellData(index: 0)
        #expect(cellData?.name == "Bitcoin", "Name should be Bitcoin")
        #expect(cellData?.symbol == "BTC", "Symbol should be BTC")
        #expect(cellData?.isNew == false, "IsNew should be false")
        #expect(cellData?.isActive == true, "IsActive should be true")
        #expect(cellData?.type.rawValue == "coin", "Type should be coin")
    }
    
    @Test func test_filterCryptosWithSelectedOptions() {
        viewModel?.filterCryptosWithSelectedOptions()
        #expect(viewModel?.filteredCryptos.count == 3, "Filterd Crypto list should have 2 items")
        #expect(viewModel?.filteredCryptos.first?.isActive == true, "isActive should be true")
    }
    
   @Test func test_filterCryptosWithOptions() {
        viewModel?.filterCryptos(isActive: true, type: "token", isNew: false)
        #expect(viewModel?.filteredCryptos.count == 1, "Filterd Crypto list should have 1 items")
        #expect(viewModel?.filteredCryptos.first?.name == "Ethereum", "Name should be Ethereum")
        #expect(viewModel?.filteredCryptos.first?.symbol == "ETH", "Symbol should be ETH")
        #expect(viewModel?.filteredCryptos.first?.isNew == false, "IsNew should be false")
        #expect(viewModel?.filteredCryptos.first?.isActive == true, "IsActive should be true")
        #expect(viewModel?.filteredCryptos.first?.type.rawValue == "token", "Type should be token")
    }
    
   @Test func test_searchCryptos() {
       viewModel?.searchCryptos(query: "Ripple")
       #expect(viewModel?.filteredCryptos.count == 1, "Filterd Crypto list should have 1 items")
       #expect(viewModel?.filteredCryptos.first?.name == "Ripple", "Name should be Ripple")
       #expect(viewModel?.filteredCryptos.first?.symbol == "XRP", "Symbol should be XRP")
       #expect(viewModel?.filteredCryptos.first?.isNew == false, "IsNew should be false")
       #expect(viewModel?.filteredCryptos.first?.isActive == false, "IsActive should be false")
       #expect(viewModel?.filteredCryptos.first?.type.rawValue == "coin", "Type should be coin")
    }
    
    @Test func test_isIndexSelected() {
        let isSelected = viewModel?.isIndexSelected(index: 0)
        #expect(isSelected == false, "Selected Crypto list should have 1 items")
    }
    
}

class MockNetworkManager: NetworkManagerProtocol {
    
    let mockJson = """
[
  {
    "name": "Bitcoin",
    "symbol": "BTC",
    "is_new": false,
    "is_active": true,
    "type": "coin"
  },
  {
    "name": "Ethereum",
    "symbol": "ETH",
    "is_new": false,
    "is_active": true,
    "type": "token"
  },
  {
    "name": "Ripple",
    "symbol": "XRP",
    "is_new": false,
    "is_active": false,
    "type": "coin"
  }]
"""
    
    func sendRequest<T>(resource: Crypto_Coins.Resource<T>, sessionConfig: URLSessionConfiguration?, completion: @escaping (Crypto_Coins.Result<T>) -> Void) where T : Decodable {
        if let data = mockJson.data(using: .utf8) {
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else { return }
            completion(.success(decodedData))
        }
    }
    
}

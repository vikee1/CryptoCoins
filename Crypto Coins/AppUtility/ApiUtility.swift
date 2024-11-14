//
//  ApiUtility.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 13/11/24.
//

// List Api here per screens
import Foundation

enum ApiUtility {
    enum CoinList {
        case coins
    }
}

extension ApiUtility.CoinList {
    var url: URL {
        switch self {
        case .coins:
            return URL(string: "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/")!
        }
    }
}

//
//  AppUtility.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 13/11/24.
//

import Reachability

struct AppUtility {
    static let userDefaults = UserDefaults.standard
    
    static func isConnectedToInternet() -> Bool {
        let isConnected = try? Reachability().connection != .unavailable
        return isConnected ?? false
    }
    
    static func fetchDecodeData<T: Decodable>(for key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    static func saveEncodeData<T: Encodable>(value: T, for key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        userDefaults.set(data, forKey: key)
    }
}

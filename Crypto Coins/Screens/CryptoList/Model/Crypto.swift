//
//  Crypto.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 12/11/24.
//
import Foundation

struct Crypto: Codable {
    let name, symbol: String
    let isNew, isActive: Bool
    let type: TypeEnum

    enum CodingKeys: String, CodingKey {
        case name, symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}

enum TypeEnum: String, Codable {
    case coin = "coin"
    case token = "token"
}

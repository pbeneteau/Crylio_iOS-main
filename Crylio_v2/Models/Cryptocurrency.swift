//
//  Cryptocurrency.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import Foundation
import UIKit


struct CryptoMarketStats {
    
    var volume24: Float
    var volume24Change: Float
    var marketCap: Float
    var marketCapChange: Float
    var availableSupply: Float
    var availableSupplyChange: Float
    var totalSupply: Float
}


class Cryptocurrency {
    
    var id: Int
    var name: String
    var slug: String
    var symbol: String
    var description: String
    
    var balance: Float
    var amount: Float
    
    var price: Float
    var change: Float
    
    var iconURL: String
    
    var marketStats: CryptoMarketStats
    
    func balanceToString() -> String {
        return balance.toDollarString()
    }
    
    func amountToString() -> String {
        return amount.toAmountString()
    }
    
    func priceToString() -> String {
        return price.toDollarString()
    }
    
    func changeToString() -> String {
        return change.toPercentString()
    }
    
    
    
    init?(id: Int,
          name: String,
          slug: String,
          symbol: String,
          description: String,
          balance: Float,
          amount: Float,
          price: Float,
          change: Float,
          iconURL: String,
          marketStats: CryptoMarketStats) {
        self.id = id
        self.name = name
        self.slug = slug
        self.symbol = symbol
        self.description = description
        self.balance = balance
        self.amount = amount
        self.price = price
        self.change = change
        self.iconURL = iconURL
        self.marketStats = marketStats
    }
    
}

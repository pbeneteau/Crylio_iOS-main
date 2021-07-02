//
//  User.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 07/05/2021.
//

import Foundation


class User {
    
    var id: Int
    var name: String
    
    var portfolios: [UserPortfolio]!

    init?(id: Int,
          name: String,
          portfolios: [UserPortfolio]) {
        self.id = id
        self.name = name
        self.portfolios = portfolios
    }
    
}

class UserPortfolio {
    
    var id: Int
    var name: String
    
    var balance: Float
    
    init?(id: Int,
          name: String,
          balance: Float) {
        self.id = id
        self.name = name
        self.balance = balance
    }
}

//
//  Exchange.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 02/07/2021.
//

import Foundation

class Exchange {
    
    var name: String
    var iconURL: String
    
    internal init(name: String, iconURL: String) {
        self.name = name
        self.iconURL = iconURL
    }
}

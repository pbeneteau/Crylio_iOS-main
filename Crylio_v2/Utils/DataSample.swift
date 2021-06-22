//
//  DataSample.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/06/2021.
//

import Foundation


let crypto1: Cryptocurrency = Cryptocurrency(id: 0,
                                             name: "Bitcoin",
                                             slug: "bitcoin",
                                             symbol: "BTC",
                                             description: "Bitcoin is first.",
                                             balance: 343492.98,
                                             amount: 11.2,
                                             price: 34467.15,
                                             change: -4.56,
                                             iconURL: "https://s2.coinmarketcap.com/static/img/coins/128x128/1.png",
                                             marketStats: CryptoMarketStats(volume24: 115149016927.31, volume24Change: 2.61, marketCap: 625760348347.31, marketCapChange: 2.61, availableSupply: 45425790652.52, availableSupplyChange: 1.5, totalSupply: 100000000000.62))!

let crypto2: Cryptocurrency = Cryptocurrency(id: 1,
                                             name: "Ripple",
                                             slug: "ripple",
                                             symbol: "XRP",
                                             description: "XRP is second.",
                                             balance: 34392.62,
                                             amount: 62923.55,
                                             price: 1.45,
                                             change: 12.52,
                                             iconURL: "https://s2.coinmarketcap.com/static/img/coins/128x128/52.png",
                                             marketStats: CryptoMarketStats(volume24: 115149016927.31, volume24Change: 2.61, marketCap: 625760348347.31, marketCapChange: 2.61, availableSupply: 45425790652.52, availableSupplyChange: 1.5, totalSupply: 100000000000.62))!

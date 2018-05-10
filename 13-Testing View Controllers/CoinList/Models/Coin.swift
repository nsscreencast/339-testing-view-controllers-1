//
//  Coin.swift
//  CoinList
//
//  Created by Ben Scheirman on 5/1/18.
//  Copyright © 2018 Fickle Bits, LLC. All rights reserved.
//

import Foundation

struct Coin {
    
    let name: String
    let symbol: String
    let imageURL: URL?
    
    static func convert(_ coinList: CoinList) -> [Coin] {
        let baseImageURL = coinList.baseImageURL
        let coins: [CoinList.Coin] = coinList.data.allCoins()
        
        return coins.map { c in
            
            let imageURL = c.imagePath.flatMap { baseImageURL.appendingPathComponent($0) }
            
            return Coin(name: c.name,
                        symbol: c.symbol,
                        imageURL: imageURL)
        }
    }
}

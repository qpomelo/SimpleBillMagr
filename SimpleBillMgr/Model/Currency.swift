//
//  Currency.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/2/6.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import Foundation
import SQLite

class Currency {
    
    var id: Int64!
    var name: String!
    var emoji: String!
    var symbol: String!
    
    init(id: Int64, name: String, emoji: String, symbol: String) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.symbol = symbol
    }
    
    static func getCurrency(id: Int64, book: CostBook = CostBook.main) -> Currency? {
        let currenciesTable = Table("currencies")
        let idC = Expression<Int64>("id")
        let nameC = Expression<String>("name")
        let emojiC = Expression<String>("emoji")
        let symbolC = Expression<String>("symbol")
        
        do {
            let db = try Connection(book.path)
            let query = currenciesTable.filter(idC == id)
            let bs = try db.prepare(query)
            for c in bs {
                let currency = Currency.init(id: c[idC], name: c[nameC], emoji: c[emojiC], symbol: c[symbolC])
                return currency
            }
        } catch {}
        return nil
    }
    
    static func getCurrencies(book: CostBook = CostBook.main) -> [Currency] {
        var currencies: [Currency] = []
        let currenciesTable = Table("currencies")
        let idC = Expression<Int64>("id")
        let nameC = Expression<String>("name")
        let emojiC = Expression<String>("emoji")
        let symbolC = Expression<String>("symbol")
        
        do {
            let db = try Connection(book.path)
            let bs = try db.prepare(currenciesTable)
            for c in bs {
                let currency = Currency.init(id: c[idC], name: c[nameC], emoji: c[emojiC], symbol: c[symbolC])
                currencies.append(currency)
            }
        } catch {}
        return currencies
    }
    
    
}

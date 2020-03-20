//
//  Cost.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/2/6.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import Foundation
// import SwiftDate
import SQLite

class Cost {
    
    var id: Int64!
    var time: Int64!
    var currency: Currency!
    var type: CostType!
    var description: String!
    var isOutlay: Bool!
    var cost: Double!
    
    init() {
        
    }
    
    init(id: Int64, time: Int64, currency: Currency, type: CostType, description: String, isOutlay: Bool, cost: Double) {
        self.id = id
        self.time = time
        self.currency = currency
        self.type = type
        self.description = description
        self.isOutlay = isOutlay
        self.cost = cost
    }
    
    static func updateCost(_ cost: Cost, book: CostBook = CostBook.main) -> Bool {
        let costsTable = Table("costs")
        let idC = Expression<Int64>("id")
        let timeC = Expression<Int64>("time")
        let currenctIdC = Expression<Int64>("currencyId")
        let typeIdC = Expression<Int64>("typeId")
        let descriptionC = Expression<String>("description")
        let isOutlayC = Expression<Bool>("isOutlay")
        let costC = Expression<Double>("cost")
        
        do {
            let db = try Connection(book.path)
            let filter = costsTable.filter(idC == cost.id)
            try db.run(filter.update(
                timeC <- cost.time,
                currenctIdC <- cost.currency.id,
                typeIdC <- cost.type.id,
                descriptionC <- cost.description,
                isOutlayC <- cost.isOutlay,
                costC <- cost.cost
            ))
        } catch {
            return false
        }
        return true
    }
    
    static func deleteCost(_ cost: Cost, book: CostBook = CostBook.main) -> Bool {
        let costsTable = Table("costs")
        let idC = Expression<Int64>("id")
        
        do {
            let db = try Connection(book.path)
            let deleteFilter = costsTable.filter(idC == cost.id)
            try db.run(deleteFilter.delete())
        } catch {
            return false
        }
        
        return true
    }
    
    static func insertCost(_ cost: Cost, book: CostBook = CostBook.main) -> Cost? {
        
        let costsTable = Table("costs")
        let timeC = Expression<Int64>("time")
        let currenctIdC = Expression<Int64>("currencyId")
        let typeIdC = Expression<Int64>("typeId")
        let descriptionC = Expression<String>("description")
        let isOutlayC = Expression<Bool>("isOutlay")
        let costC = Expression<Double>("cost")
        
        var costId: Int64 = 0
        do {
            let db = try Connection(book.path)
            costId = try db.run(costsTable.insert(
                timeC <- cost.time,
                currenctIdC <- cost.currency.id,
                typeIdC <- cost.type.id,
                descriptionC <- cost.description,
                isOutlayC <- cost.isOutlay,
                costC <- cost.cost
            ))
        } catch {
            return nil
        }
        
        cost.id = costId
        return cost
    }
    
    static func getCost(id: Int64, book: CostBook = CostBook.main) -> Cost? {
        var costList: [Cost] = []
        
        let costsTable = Table("costs")
        let idC = Expression<Int64>("id")
        let timeC = Expression<Int64>("time")
        let currenctIdC = Expression<Int64>("currencyId")
        let typeIdC = Expression<Int64>("typeId")
        let descriptionC = Expression<String>("description")
        let isOutlayC = Expression<Bool>("isOutlay")
        let costC = Expression<Double>("cost")
        
        do {
            let db = try Connection(book.path)
            let query = costsTable.filter(idC == id)
            let bs = try db.prepare(query)
            for cost in bs {
                let currencyOp = Currency.getCurrency(id: cost[currenctIdC])
                if currencyOp == nil {
                    continue
                }
                let currency = currencyOp!
                let costTypeOp = CostType.getCostType(id: cost[typeIdC])
                if costTypeOp == nil {
                    continue
                }
                let costType = costTypeOp!
                let cost = Cost.init(id: cost[idC], time: cost[timeC], currency: currency, type: costType, description: cost[descriptionC], isOutlay: cost[isOutlayC], cost: cost[costC])
                costList.append(cost)
            }
        } catch {}
        
        if costList.count != 0 {
            return costList[0]
        }
        return nil
    }
    
    static func getCosts(startTime: Int64 = TimeTool.getTodayMorningTimestamp(), endTime: Int64 = TimeTool.getTodayEveningTimestamp(), book: CostBook = CostBook.main) -> [Cost] {
        var costList: [Cost] = []
        
        let costsTable = Table("costs")
        let idC = Expression<Int64>("id")
        let timeC = Expression<Int64>("time")
        let currenctIdC = Expression<Int64>("currencyId")
        let typeIdC = Expression<Int64>("typeId")
        let descriptionC = Expression<String>("description")
        let isOutlayC = Expression<Bool>("isOutlay")
        let costC = Expression<Double>("cost")
        
        do {
            let db = try Connection(book.path)
            let query = costsTable.filter(timeC >= startTime && timeC <= endTime).order(timeC)
            let bs = try db.prepare(query)
            for cost in bs {
                let currencyOp = Currency.getCurrency(id: cost[currenctIdC])
                if currencyOp == nil {
                    continue
                }
                let currency = currencyOp!
                let costTypeOp = CostType.getCostType(id: cost[typeIdC])
                if costTypeOp == nil {
                    continue
                }
                let costType = costTypeOp!
                let cost = Cost.init(id: cost[idC], time: cost[timeC], currency: currency, type: costType, description: cost[descriptionC], isOutlay: cost[isOutlayC], cost: cost[costC])
                costList.append(cost)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return costList
    }
    
}

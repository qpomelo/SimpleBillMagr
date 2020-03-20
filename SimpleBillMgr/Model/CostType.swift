//
//  CostType.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/2/6.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class CostType {
    
    var id: Int64!
    var color: UIColor!
    var icon: String!
    var title: String!
    var isOutlay: Bool!
    
    init(id: Int64, color: UIColor, icon: String, title: String, isOutlay: Bool) {
        self.id = id
        self.color = color
        self.icon = icon
        self.title = title
        self.isOutlay = isOutlay
        
    }
    
    static func updateCostType(_ costType: CostType, book: CostBook = CostBook.main) -> Bool {
        let costTypeTable = Table("costType")
        let idC = Expression<Int64>("id")
        let colorC = Expression<String>("color")
        let iconC = Expression<String>("icon")
        let titleTextC = Expression<String>("text")
        let isOutlayC = Expression<Bool>("isOutlay")
        
        do {
            let db = try Connection(book.path)
            let filter = costTypeTable.filter(idC == costType.id)
            try db.run(filter.update(
                colorC <- costType.color.toHexString(),
                iconC <- costType.icon,
                titleTextC <- costType.title,
                isOutlayC <- costType.isOutlay
            ))
        } catch {
            return false
        }
        return true
    }
    
    static func deleteCostType(_ costType: CostType, book: CostBook = CostBook.main) -> Bool {
        let costTypeTable = Table("costType")
        let idC = Expression<Int64>("id")
        
        do {
            let db = try Connection(book.path)
            let deleteFilter = costTypeTable.filter(idC == costType.id)
            try db.run(deleteFilter.delete())
        } catch {
            return false
        }
        
        return true
    }
    
    static func insertCostType(_ costType: CostType, book: CostBook = CostBook.main) -> CostType? {
        let costTypeTable = Table("costType")
        let colorC = Expression<String>("color")
        let iconC = Expression<String>("icon")
        let titleTextC = Expression<String>("text")
        let isOutlayC = Expression<Bool>("isOutlay")
        
        var costTypeId: Int64 = 0
        do {
            let db = try Connection(book.path)
            costTypeId = try db.run(costTypeTable.insert(
                colorC <- costType.color.toHexString(),
                iconC <- costType.icon,
                titleTextC <- costType.title,
                isOutlayC <- costType.isOutlay
            ))
        } catch {
            return nil
        }
        
        costType.id = costTypeId
        return costType
    }
    
    static func getCostType(id: Int64, book: CostBook = CostBook.main) -> CostType? {
        var costTypeList: [CostType] = []
        
        let costTypeTable = Table("costType")
        let idC = Expression<Int64>("id")
        let colorC = Expression<String>("color")
        let iconC = Expression<String>("icon")
        let titleTextC = Expression<String>("text")
        let isOutlayC = Expression<Bool>("isOutlay")
        
        do {
            let db = try Connection(book.path)
            let query = costTypeTable.filter(idC == id)
            let bs = try db.prepare(query)
            for cost in bs {
                let cost = CostType.init(id: cost[idC], color: UIColor.init(hexString: cost[colorC]), icon: cost[iconC], title: cost[titleTextC], isOutlay: cost[isOutlayC])
                costTypeList.append(cost)
            }
        } catch {}
        
        if costTypeList.count != 0 {
            return costTypeList[0]
        }
        return nil
    }
    
    static func getCostTypes(isOutlay: Bool, book: CostBook = CostBook.main) -> [CostType] {
        var costTypeList: [CostType] = []
        
        let costTypeTable = Table("costType")
        let idC = Expression<Int64>("id")
        let colorC = Expression<String>("color")
        let iconC = Expression<String>("icon")
        let titleTextC = Expression<String>("text")
        let isOutlayC = Expression<Bool>("isOutlay")
        
        do {
            let db = try Connection(book.path)
            let query = costTypeTable.filter(isOutlayC == isOutlay)
            let bs = try db.prepare(query)
            for cost in bs {
                let cost = CostType.init(id: cost[idC], color: UIColor.init(hexString: cost[colorC]), icon: cost[iconC], title: cost[titleTextC], isOutlay: cost[isOutlayC])
                costTypeList.append(cost)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return costTypeList
    }
    
    static func getCostTypes(book: CostBook = CostBook.main) -> [CostType] {
        var costTypeList: [CostType] = []
        
        let costTypeTable = Table("costType")
        let idC = Expression<Int64>("id")
        let colorC = Expression<String>("color")
        let iconC = Expression<String>("icon")
        let titleTextC = Expression<String>("text")
        let isOutlayC = Expression<Bool>("isOutlay")
        
        do {
            let db = try Connection(book.path)
            let bs = try db.prepare(costTypeTable)
            for cost in bs {
                let cost = CostType.init(id: cost[idC], color: UIColor.init(hexString: cost[colorC]), icon: cost[iconC], title: cost[titleTextC], isOutlay: cost[isOutlayC])
                costTypeList.append(cost)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return costTypeList
    }
    
    func getIcon() -> UIImage? {
        
        if icon.subString(start: 0, length: 11) == "CustomIcon-" {
            // 自定义图标
            let image = loadImageFromDiskWith(fileName: icon)
            return image
        } else {
            // 内置图标
            return UIImage(named: icon)
        }
        
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
    
}

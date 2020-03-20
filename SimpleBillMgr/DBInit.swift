//
//  DBInit.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/31.
//  Copyright © 2019 QPomelo. All rights reserved.
//
//  什么傻逼代码
//  TODO 重构
//

import Foundation
import SQLite

class DBInit {
    
    static let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    static func initDb(dbName: String = "main") -> Bool {
        
        let fmanager = FileManager.default
        if !fmanager.fileExists(atPath: "\(path)/\(dbName).db") {
            do {
                let db = try Connection("\(path)/\(dbName).db")
                let configTable = Table("config")
                try db.run(configTable.create{ t in
                    t.column(Expression<String>("name"))
                    t.column(Expression<String>("value"))
                })
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        
        if !initCostTable() {
            return false
        }
        if !initCurrency() {
            return false
        }
        if !initCostTypes() {
            return false
        }
        
        if Config.getConfig("lastUseVersion") == nil {
            _ = Config.insertConfig(Config.init(name: "lastUseVersion", value: "0"))
        }
        if Config.getConfig("preferredCurrencyId") == nil {
            _ = Config.insertConfig(Config.init(name: "preferredCurrencyId", value: "1"))
        } else {
            AppDelegate.preferredCurrencyId = Int((Config.getConfig("preferredCurrencyId")?.value)!)!
        }
        
        return true
        
    }
    
    static func initCostTable(dbName: String = "main") -> Bool {
        do {
            let db = try Connection("\(path)/\(dbName).db")
            
            if tableExists("costs", db: db) {
                return true;
            }
            
            let costsTable = Table("costs")
            try db.run(costsTable.create{ t in
                t.column(Expression<Int64>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int64>("time"))
                t.column(Expression<Int64>("currencyId"))
                t.column(Expression<Int64>("typeId"))
                t.column(Expression<String>("description"))
                t.column(Expression<Bool>("isOutlay"))
                t.column(Expression<Double>("cost"))
            })
            return true
        } catch {
            print(error.localizedDescription)
            return false;
        }
    }
    
    static func initCostTypes(dbName: String = "main") -> Bool {
        do {
            let db = try Connection("\(path)/\(dbName).db")
            
            if tableExists("costType", db: db) {
                return true;
            }
            
            let costTypeTable = Table("costType")
            try db.run(costTypeTable.create{ t in
                t.column(Expression<Int64>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("color"))
                t.column(Expression<String>("icon"))
                t.column(Expression<String>("text"))
                t.column(Expression<Bool>("isOutlay"))
            })
            
            let colors: [String] = ["#4A90E2","#FFDB00","#2FC6C9","#E85E5E","#2FC991","#74778A","#F4A668","#7CB0FF","#756DDD","#6DDD98","#DDA86D","#DD836D","#6DDDC0","#E4A85A","#EC6D6D","#ECC86D","#475159","#EEC57C","#829B83","#DE7171","#DAAF70","#475159"]
            let icons: [String] = ["BillTypeMetro","BillTypeDining","BillTypeShopping","BillTypeDaily","BillTypeFruit","BillTypePayment","BillTypeSnack","BillTypeGame","BillTypeSport","BillTypePhone","BillTypeClothes","BillTypeGift","BillTypeTrip","BillTypeSoftware","BillTypeMedical","BillTypeBook","BillTypeOther","BillTypeWage","BillTypePartTime","BillTypeBonus","BillTypePocketMoney","BillTypeOther"]
            let textsCN: [String] = ["交通", "餐饮", "购物", "日用", "蔬果", "还款", "零食", "娱乐", "运动", "通讯", "衣服", "送礼", "旅行", "软件", "医疗", "书籍", "其他", "工资", "兼职", "奖金", "零花", "其他"]
            let outlays: [Bool] = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false]
            
            let colorC = Expression<String>("color")
            let iconC = Expression<String>("icon")
            let textC = Expression<String>("text")
            let isOutlayC = Expression<Bool>("isOutlay")
            
            var index = 0
            for color in colors {
                do{
                    try db.run(costTypeTable.insert(
                        colorC <- color,
                        iconC <- icons[index],
                        textC <- textsCN[index],
                        isOutlayC <- outlays[index]
                    ))
                }
                catch{
                    print(error.localizedDescription)
                    return false;
                }
                index += 1
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false;
        }
    }
    
    // NSLocale.current.localizedString(forCurrencyCode: currency[0]) ?? "未知货币"
    // (Locale.preferredLanguages[0] as String).components(separatedBy: "-").first // zh, en, jp ...
    
    static func initCurrency(dbName: String = "main") -> Bool {
        do {
            let db = try Connection("\(path)/\(dbName).db")
            
            if tableExists("currencies", db: db) {
                return true;
            }
            
            let currenciesTable = Table("currencies")
            try db.run(currenciesTable.create{ t in
                t.column(Expression<Int64>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<String>("emoji"))
                t.column(Expression<String>("symbol"))
            })
            
            let currencies = [["CNY","🇨🇳","¥"],["HKD","🇭🇰","$"],["NTD","🇹🇼","$"],["KRW","🇰🇷","₩"],["VND","🇻🇳","D"],["JPY","🇯🇵","¥"],["SGD","🇸🇬","$"],["INR","🇮🇳","R"],["EUR","🇪🇺","€"],["GBP","🇬🇧","￡"],["CAD","🇨🇦","$"],["USD","🇺🇸","$"],["AUD","🇦🇺","$"],["NZD","🇳🇿","$"]]
            
            let nameC = Expression<String>("name")
            let emojiC = Expression<String>("emoji")
            let symbolC = Expression<String>("symbol")
            
            for currency in currencies {
                do{
                    try db.run(currenciesTable.insert(
                        nameC <- currency[0],
                        emojiC <- currency[1],
                        symbolC <- currency[2]))
                }
                catch{
                    print(error.localizedDescription)
                    return false;
                }
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false;
        }
    }
    
    static func tableExists(_ tableName: String, db: Connection) -> Bool{
        do{
            let tables = Table("sqlite_master")
            let type = Expression<String>("type")
            let name = Expression<String>("name")
            print(try db.prepare(tables))
            print(tables.count)
            
            for table in try db.prepare(tables){
                if table[type] == "table" && table[name] == tableName{
                    return true
                }
            }
            return false
        }catch{
            return false
        }
    }
    
    
}

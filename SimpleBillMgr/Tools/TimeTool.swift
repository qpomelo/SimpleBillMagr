//
//  TimeTool.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/2/6.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import Foundation

class TimeTool {
    
    static func nowTimestamp() -> Int64 {
        return date2timestamp(Date.init())
    }
    
    // Swift Date 转 Unix Time Stamp
    static func date2timestamp(_ date: Date) -> Int64{
        let timeInterval:TimeInterval = date.timeIntervalSince1970
        let timeStamp = Int64(timeInterval)
        return timeStamp - TimeTool.getGMTHourSeconds()
    }
    // Unix Time Stamp 转 Swift Date
    static func timestamp2DateTime(_ timestamp: Int64) -> Date{
        let timeInterval:TimeInterval = TimeInterval.init(timestamp +  TimeTool.getGMTHourSeconds())
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
    // 获取今天早上 00:00:00 的 Unix Time Stamp
    static func getTodayMorningTimestamp() -> Int64{
        return getMorningTimestamp(Date())
    }
    // 获取今天晚上 23:59:59 的 Unix Time Stamp
    static func getTodayEveningTimestamp() -> Int64{
        return getEveningTimestamp(Date())
    }
    
    // 获取某天早上 00:00:00 的 Unix Time Stamp
    static func getMorningTimestamp(_ date: Date) -> Int64{
        let calendar = NSCalendar.init(identifier: .chinese)
        let components = calendar?.components([.year,.month,.day], from: date)
        let date = calendar?.date(from: components!)
        return date2timestamp(date!) + getGMTHourSeconds()
    }
    // 获取某天晚上 23:59:59 的 Unix Time Stamp
    static func getEveningTimestamp(_ date: Date) -> Int64{
        return getMorningTimestamp(date) + 86399
    }
    
    static func getGMTHourSeconds() -> Int64 {
        let tz = TimeZone.current.secondsFromGMT(for: Date())
        return Int64(tz)
    }
}

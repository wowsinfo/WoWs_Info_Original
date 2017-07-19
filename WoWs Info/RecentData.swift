//
//  RecentData.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecentData {
    
    let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
    var recentInfoAPI = "";
    static var recentDataJson: JSON!
    var accountId: String!
    
    struct dataIndex {
        static let battle = 0
        static let win = 1
        static let damage = 2
    }
    
    // Make up request string
    init(account: String) {
        accountId = account
        recentInfoAPI = "https://api.worldofwarships.\(server)/wows/account/statsbydate/?application_id=4e54ba74077a8230e457bf3e7e9ae858&account_id=\(account)&language=en&fields=pvp.wins%2Cpvp.battles%2Cpvp.damage_dealt&dates=" + getDateString()
        print(recentInfoAPI)
    }
    
    func getRecentData() {
        
        let request = URLRequest(url: URL(string: recentInfoAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("Error: \(error!)")
            } else {
                let recentJson = JSON(data!)
                if recentJson["status"].stringValue == "ok" {
                    // Pass data to recentDataJson
                    RecentData.recentDataJson = recentJson["data"][self.accountId]["pvp"] as JSON
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: Make a string containing 20170325,20170324...
    func getDateString() -> String {
        let calender = Calendar.current
        
        // Get last 8 days
        let eightDayAgo = dateToString(date: calender.date(byAdding: .day, value: -8, to: Date())!)
        let nineDayAgo = dateToString(date: calender.date(byAdding: .day, value: -9, to: Date())!)
        let tenDayAgo = dateToString(date: calender.date(byAdding: .day, value: -10, to: Date())!)
        let yesterday = dateToString(date: calender.date(byAdding: .day, value: -1, to: Date())!)
        let twoDayAgo = dateToString(date: calender.date(byAdding: .day, value: -2, to: Date())!)
        let threeDayAgo = dateToString(date: calender.date(byAdding: .day, value: -3, to: Date())!)
        let fourDayAgo = dateToString(date: calender.date(byAdding: .day, value: -4, to: Date())!)
        let fiveDayAgo = dateToString(date: calender.date(byAdding: .day, value: -5, to: Date())!)
        let sixDayAgo = dateToString(date: calender.date(byAdding: .day, value: -6, to: Date())!)
        let sevenDayAgo = dateToString(date: calender.date(byAdding: .day, value: -7, to: Date())!)
        
        
        return "\(yesterday)%2C\(twoDayAgo)%2C\(threeDayAgo)%2C\(fourDayAgo)%2C\(fiveDayAgo)%2C\(sixDayAgo)%2C\(sevenDayAgo)%2C\(eightDayAgo)%2C\(nineDayAgo)%2C\(tenDayAgo)"
    }
    
    func dateToString(date: Date) -> String {
        let betterString = "\(date)".replacingOccurrences(of: "-", with: "")
        return betterString.substring(to: betterString.index(betterString.startIndex, offsetBy: 8))
    }
    
    // MARK: Helper function
    static func getRecentDataString() -> [[String]] {
        var data = [[String]]()
        if self.recentDataJson.count == 0 { return data }
        let sortedJson = self.recentDataJson.sorted(by: {$1.0 < $0.0})
        
        // loop count - 1 time to get recent 7 days data
        let loopCount = sortedJson.count
        if loopCount > 1 {
            for i in 0..<loopCount - 1 {
                let battle = sortedJson[i].1["battles"].doubleValue - sortedJson[i + 1].1["battles"].doubleValue
                let wins = sortedJson[i].1["wins"].doubleValue - sortedJson[i + 1].1["wins"].doubleValue
                let damage = sortedJson[i].1["damage_dealt"].doubleValue - sortedJson[i + 1].1["damage_dealt"].doubleValue
                
                let totalBattle = String(format: "%.0f", battle)
                let winrate = String(format: "%.2f", wins/battle * 100)
                let averageDamage = String(format: "%.2f", damage/battle)
                
                data.append([totalBattle,winrate,averageDamage])
            }
        }
        
        return data
    }

}

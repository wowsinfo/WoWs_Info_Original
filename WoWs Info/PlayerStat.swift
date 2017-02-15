//
//  PlayerStat.swift
//  WoWs Info
//
//  Created by Henry Quan on 15/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class PlayerStat{
        
    // Player Stat API url
    var server = ""
    let applicationID = "***ApplicationID***"
    var playerDataAPI = ""
    
    // Index of passing data
    struct dataIndex {
        static let totalBattles = 0
        static let winRate = 1
        static let averageDamage = 2
        static let averageExp = 3
        static let killDeathRatio = 4
        static let servicelevel = 5
        static let playTime = 6
        static let hitRatio = 7
    }
    
    init() {
        // Make API Url
        let serverIndex = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        server = ServerUrl(serverIndex: serverIndex).getServerDomain()
        playerDataAPI = "https://api.worldofwarships.\(server)/wows/account/info/?application_id=\(applicationID)"
    }
    
    func getDataFromAPI(account: String, success: @escaping ([String]) -> ()) {
        
        // Get data from API, wow this is a really string...
        playerDataAPI += "&account_id=\(account)&language=en&fields=statistics.pvp.xp%2Cstatistics.pvp.survived_battles%2Cstatistics.pvp.frags%2Cstatistics.pvp.wins%2Cstatistics.pvp.main_battery.hits%2Cstatistics.pvp.main_battery.shots%2Ccreated_at%2Chidden_profile%2Cleveling_tier%2Cstatistics.pvp.battles%2Cstatistics.pvp.damage_dealt"
        
        let request = URLRequest(url: URL(string: playerDataAPI)!)
        
        // Get data
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("Error: \(error)")
            } else {
                if let data = data {
                    do {
                        // Make sure json is valid
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                        
                        let dataJson = json["data"] as AnyObject
                        let playerJson = dataJson[account] as AnyObject
                        let isHidden = playerJson["hidden_profile"] as? Bool
                        
                        // There is no data if account is hidden
                        if (isHidden)! {
                            success(["HIDDEN"])
                        } else {
                            let serviceLevel = playerJson["leveling_tier"] as! Double
                            let time = playerJson["created_at"] as! Double
                            
                            let statisticsJson = playerJson["statistics"] as AnyObject
                            let pvpJson = statisticsJson["pvp"] as AnyObject
                            
                            let battles = pvpJson["battles"] as! Double
                            let wins = pvpJson["wins"] as! Double
                            let xp = pvpJson["xp"] as! Double
                            let frags = pvpJson["frags"] as! Double
                            let survived_battles = pvpJson["survived_battles"] as! Double
                            let damage = pvpJson["damage_dealt"] as! Double
                            
                            let mainBatteryJson = pvpJson["main_battery"] as AnyObject
                            let hits = mainBatteryJson["hits"] as! Double
                            let shots = mainBatteryJson["shots"] as! Double
                            
                            var information = self.calculateStatisticsWithData(battles: battles, xp: xp, wins: wins, frags: frags, damage: damage, survived: survived_battles, hits: hits, shots: shots)
                            information[dataIndex.servicelevel] = String(format: "%.0f", serviceLevel)
                            information[dataIndex.playTime] = "\(self.getDateFromUnixTime(time: time))"
                            
                            success(information)
                        }
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }
                }
            }
        }
        task.resume()
        
    }
    
    func calculateStatisticsWithData(battles: Double, xp: Double, wins: Double, frags: Double, damage: Double, survived: Double, hits: Double, shots: Double) -> [String] {
        
        // Make room for everyone
        var information = [String]()
        for _ in 0...7 {
            information.append("")
        }
        
        // All in string format
        let totalBattles = String(format: "%.0f", battles)
        var winRate = "0"
        var averageDamage = "0"
        var averageExp = "0"
        var killDeathRatio = "0"
        var hitRatio = "0"
        
        
        // Calculate stat
        if (battles > 0) {
            winRate = "\(Double(round(100 * (wins / battles * 100)) / 100))%"
            averageDamage = String(format: "%.0f", Double(round(damage / battles)))
            averageExp = String(format: "%.0f", Double(round(xp / battles)))
            killDeathRatio = String(format: "%.2f", 100 * (frags / (battles - survived)) / 100)
            if (shots > 0) {
                hitRatio = "\(Double(round(100 * (hits / shots * 100)) / 100))%"
            }
        }
        
        information[dataIndex.averageDamage] = averageDamage
        information[dataIndex.winRate] = winRate
        information[dataIndex.totalBattles] = totalBattles
        information[dataIndex.averageExp] = averageExp
        information[dataIndex.killDeathRatio] = killDeathRatio
        information[dataIndex.hitRatio] = hitRatio
        
        return information
        
    }
    
    func getDateFromUnixTime(time: Double) -> Int {
        
        let calender = NSCalendar.current
        let startingDate = calender.startOfDay(for: NSDate.init(timeIntervalSince1970: time) as Date)
        let currentDate = calender.startOfDay(for: NSDate() as Date)
        
        let dayDifference = calender.dateComponents([.day], from: startingDate, to: currentDate)
        print(dayDifference)
        return dayDifference.day!
        
    }
    
}

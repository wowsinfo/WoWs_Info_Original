//
//  ChineseServer.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChineseServer: NSObject {
    
    var server = 0
    var player = ""
    var playerID = ""
    
    struct ServerIndex {
        static let north = 0
        static let south = 1
    }
    
    struct DataIndex {
        static let rank = 0
        static let nickname = 1
        static let clan = 2
        static let id = 3
        static let website = 4
    }
    
    struct ShipDataIndex {
        static let winrate = 0
        static let damage = 1
        static let battle = 2
        static let rank = 3
        static let shipID = 4
        static let shipImage = 5
        static let shipTierName = 6
        static let shipType = 7
        static let frag = 8
        static let exp = 9
        static let killDeath = 10
        static let rating = 11
        static let tier = 12
        static let allDamage = 13
        static let allWin = 14
        static let kill = 15
    }
    
    // Get basic info
    init(player: String, server: Int) {
        self.server = server
        self.player = player
    }
    
    init(id: String) {
        self.playerID = id
    }
    
    // MARK: Player Information
    func getPlayerInformation(success: @escaping ([String]) -> ()) {
        
        let serverName = getServerFrom(index: server)
        if let url = URL(string: "http://rank.kongzhong.com/Data/action/WowsAction/getLogin?name=\(player.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&zone=\(serverName)") {
            // Only if url is valid
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["errno"] == JSON.null {
                        // Only if it is a valid name
                        success([dataJson["rank"].stringValue, dataJson["nick"].stringValue, dataJson["clan"].stringValue, dataJson["account_db_id"].stringValue, "http://rank.kongzhong.com/wows/index.html?name=\(self.player.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&zone=\(serverName)"])
                    } else {
                        success([String]())
                    }
                }
            }
            task.resume()
        }
    }
    
    func getServerFrom(index: Int) -> String {
        switch index {
        case 0:
            return "north"
        case 1:
            return "south"
        default:
            return ""
        }
    }
    
    // MARK: Ship Information
    func getShipInformation(rankJson: JSON, success: @escaping ([[String]]) -> ()) {
        
        if let url = URL(string: "http://rank.kongzhong.com/Data/action/WowsAction/getShipInfo?aid=\(playerID)") {
            // Only if url is valid
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    var shipData = [[String]]()
                    let dataJson = JSON(data!)
                    // Calculate for all ships
                    for ship in dataJson {
                        let battle = ship.1["battles"].doubleValue
                        if battle == 0 { continue }
                        let win = ship.1["wins"].doubleValue
                        let damage = ship.1["damage"].doubleValue
                        
                        let winrate = String(format: "%.1f", round(100 * (win / battle) * 100) / 100) + "%"
                        let averageDamage = String(format: "%.0f", round(damage / battle))
                        
                        let shipID = ship.1["id"]["vehicleTypeCd"].stringValue
                        // Does not count beta ships
                        if Shipinformation.ShipJson[shipID] == JSON.null { continue }
                        var rank = "0"
                        if rankJson[shipID] != JSON.null {
                            rank = "\(rankJson[shipID])"
                        }
                        
                        let kill = ship.1["killship"].doubleValue
                        let averageFrag = String(format: "%.2f", round(kill / battle * 100) / 100)
                        let averageExp = String(format: "%.0f", round(ship.1["exp"].doubleValue / battle))
                        
                        var death = battle - ship.1["alive"].doubleValue
                        if death == 0 { death = 1 }
                        let killDeath = String(format: "%.2f", round(kill / death * 100) / 100)
                        
                        var teamBattle = ship.1["teambattles"].doubleValue
                        if teamBattle == 0 { teamBattle = 1 }
                        let teamWinrate = String(format: "%.1f", round(100 * (ship.1["teamwins"].doubleValue / teamBattle * 100) / 100))
                        
                        let pr = ShipRating().getRatingForShips(Damage: damage / battle, WinRate: win / battle, Frags: kill / battle, ID: shipID)
                        
                        shipData.append([winrate + " (\(teamWinrate)%)", averageDamage + " (\(ship.1["maxdamage"]))", String(format: "%.0f%", battle) + " (\(String(format: "%.0f%", teamBattle)))", rank, shipID, "http://xvm.qingcdn.com/wikiwows/ship/\(Shipinformation.ShipJson[shipID]["ship_id_str"]).png", "等级 \(Shipinformation.ShipJson[shipID]["tier"]) \(Shipinformation.ShipJson[shipID]["name"])", "\(Shipinformation.ShipJson[shipID]["type"])", averageFrag, averageExp + " (\(ship.1["maxexp"]))", killDeath, pr, "\(Shipinformation.ShipJson[shipID]["tier"])", "\(damage)", "\(win)", "\(kill)"])
                    }
                    
                    // Sort array
                    shipData.sort(by: {
                        // If they have same rating
                        if Int($0[11].components(separatedBy: "|")[1])! == Int($1[11].components(separatedBy: "|")[1])! {
                            return Int($0[12])! > Int($1[12])!
                        }
                        return Int($0[11].components(separatedBy: "|")[1])! > Int($1[11].components(separatedBy: "|")[1])!
                    })
                    success(shipData)
                }
            }
            task.resume()
        }
    }
    
    // MARK: Rank Information
    func getShipRank(success: @escaping (JSON) -> ()) {
        if let url = URL(string: "http://rank.kongzhong.com/Data/playerrank/\(playerID).json") {
            // Only if url is valid
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    success(JSON(data!))
                }
            }
            task.resume()
        }
    }
    
    // MARK: Recent Information
    func getRecentInformation(success: @escaping ([[String]]) -> ()) {
        if let url = URL(string: "http://rank.kongzhong.com/Data/action/WowsAction/getDayInfo?aid=\(playerID)") {
            // Only if url is valid
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    var usefulData = [[String]]()
                    let dataJson = JSON(data!)
                    
                    if dataJson.count == 0 { success([[String]]()) }
                    // Get Basic Information
                    for recent in dataJson {
                        usefulData.append([recent.1["battles"].stringValue, recent.1["wins"].stringValue, recent.1["damage"].stringValue, recent.1["insert_date"]["time"].stringValue])
                    }
                    
                    // Sort it by time
                    usefulData.sort(by: {$0[3] > $1[3]})
                    var currTime = ""
                    var recentData = [[String]]()
                    var i = 0
                    for recent in usefulData {
                        if currTime == "" {
                            // Update time
                            currTime = recent[3]
                            recentData.append([recent[0], recent[1], recent[2]])
                        } else if recent[3] == currTime {
                            // Same day, add numbers
                            let battle = Int(recent[0])! + Int(recentData[i][0])!
                            let win = Int(recent[1])! + Int(recentData[i][1])!
                            let damage = Int(recent[2])! + Int(recentData[i][2])!
                            
                            recentData[i] = ["\(battle)", "\(win)", "\(damage)"]
                        } else {
                            // Another day, update index, update data
                            recentData[i] = self.calRecentData(recentData: recentData, i: i)
                            
                            currTime = recent[3]
                            recentData.append([recent[0], recent[1], recent[2]])
                            i += 1
                        }
                        print("\(currTime)|\(recent[3])|\(currTime == recent[3])\n")
                    }
                    
                    // Calculate for the last
                    recentData[i] = self.calRecentData(recentData: recentData, i: i)
                    success(recentData)
                }
            }
            task.resume()
        }
    }
    
    func calRecentData(recentData: [[String]], i: Int) -> [String] {
        let battle = Double(recentData[i][0])!
        let win = Double(recentData[i][1])!
        let damage = Double(recentData[i][2])!
        let recentBattle = String(format: "%.0f", battle)
        let winrate = String(format: "%.1f", round(100 * win / battle))
        let avgDamage = String(format: "%.0f", round(damage / battle))
        return [recentBattle, winrate, avgDamage]
    }
    
}

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
        default:
            return "south"
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
                        var rank = "无"
                        if rankJson[shipID] != JSON.null {
                            rank = "\(rankJson[shipID])"
                        }
                        
                        let kill = ship.1["killship"].doubleValue
                        let averageFrag = String(format: "%.2f", round(kill / battle))
                        let averageExp = String(format: "%.0f", round(ship.1["exp"].doubleValue / battle))
                        
                        var death = battle - ship.1["alive"].doubleValue
                        if death == 0 { death = 1 }
                        let killDeath = String(format: "%.2f", round((kill / death * 100) / 100))
                        
                        var teamBattle = ship.1["teambattles"].doubleValue
                        if teamBattle == 0 { teamBattle = 1 }
                        let teamWinrate = String(format: "%.1f", round(100 * (ship.1["teamwins"].doubleValue / teamBattle * 100) / 100))
                        
                        shipData.append([winrate + " (\(teamWinrate)%)", averageDamage + " (\(ship.1["maxdamage"]))", String(format: "%.0f%", battle) + " (\(String(format: "%.0f%", teamBattle)))", rank, shipID, "http://xvm.qingcdn.com/wikiwows/ship/\(Shipinformation.ShipJson[shipID]["ship_id_str"]).png", "等级 \(Shipinformation.ShipJson[shipID]["tier"]) \(Shipinformation.ShipJson[shipID]["name"])", "\(Shipinformation.ShipJson[shipID]["type"])", averageFrag, averageExp + " (\(ship.1["maxexp"]))", killDeath])
                    }
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
    
}

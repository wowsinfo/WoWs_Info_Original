//
//  Achievements.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Achievements {
    
    var achievementsAPI: String!
    static var achievementJson: JSON!
    
    struct dataIndex {
        static let name = 0
        static let description = 1
        static let image = 2
        static let image_disable = 3
        static let hidden = 4
    }
    
    init() {
        // Setup achievementsAPI
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        achievementsAPI = "https://api.worldofwarships." + server + "/wows/encyclopedia/achievements/?application_id=4e54ba74077a8230e457bf3e7e9ae858&fields=battle.name%2Cbattle.hidden%2Cbattle.description%2Cbattle.image%2Cbattle.image_inactive" + Language.getLanguageString()
    }
    
    func getAchievementJson() {
        
        let request = URLRequest(url: URL(string: achievementsAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    Achievements.achievementJson = dataJson["data"]["battle"]
                }
            }
        }
        task.resume()
        
    }
    
    static func getAchievementInformation() -> [[String]] {
        
        var achievementInfo = [[String]]()
        for achievement in Achievements.achievementJson {
            achievementInfo.append([achievement.1["name"].stringValue, achievement.1["description"].stringValue, achievement.1["image"].stringValue, achievement.1["image_inactive"].stringValue, achievement.1["hidden"].stringValue])
        }
        // Sort Achievement by Hidden
        achievementInfo.sort(by: {Int($1[4])! > Int($0[4])!})
        print(achievementInfo)
        return achievementInfo
        
    }
    
}

class Ships {
    
    var shipsAPI: String!
    static var shipJson: JSON!
    
    struct dataIndex {
        static let name = 0
        static let description = 1
        static let image = 2
        static let tier = 3
        static let type = 4
        static let isPremium = 5
        static let priceGold = 6
        static let priceCredit = 7
        static let nation = 8
        static let shipID = 9
    }
    
    init() {
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        shipsAPI = "https://api.worldofwarships." + server + "/wows/encyclopedia/ships/?application_id=4e54ba74077a8230e457bf3e7e9ae858&fields=tier%2Ctype%2Cship_id%2Cmodules%2Cdescription%2Cis_premium%2Cname%2Cnation%2Cprice_credit%2Cprice_gold%2Cimages.small" + Language.getLanguageString()
    }
    
    func getShipJson() {
        
        let request = URLRequest(url: URL(string: shipsAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    Ships.shipJson = dataJson["data"]
                }
            }
        }
        task.resume()
        
    }
    
    static func getShipInformation() -> [[String]] {
        
        var shipInfo = [[String]]()
        for ship in Ships.shipJson {
            shipInfo.append([ship.1["name"].stringValue,ship.1["description"].stringValue,ship.1["images"]["small"].stringValue,ship.1["tier"].stringValue,ship.1["type"].stringValue,ship.1["is_premium"].stringValue,ship.1["price_gold"].stringValue,ship.1["price_credit"].stringValue,ship.1["nation"].stringValue,ship.1["ship_id"].stringValue])
        }
        
        // Sort Achievement by tier
        shipInfo.sort(by: {Int($1[3])! < Int($0[3])!})
        return shipInfo
        
    }
    
}

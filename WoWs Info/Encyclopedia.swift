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
        achievementsAPI = "https://api.worldofwarships." + server + "/wows/encyclopedia/achievements/?application_id=***ApplicationID***&fields=battle.name%2Cbattle.hidden%2Cbattle.description%2Cbattle.image%2Cbattle.image_inactive" + Language.getLanguageString()
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
        if Achievements.achievementJson != nil {
            for achievement in Achievements.achievementJson {
                achievementInfo.append([achievement.1["name"].stringValue, achievement.1["description"].stringValue, achievement.1["image"].stringValue, achievement.1["image_inactive"].stringValue, achievement.1["hidden"].stringValue])
            }
            // Sort Achievement by Hidden
            achievementInfo.sort(by: {Int($1[4])! > Int($0[4])!})
            print(achievementInfo)

        }
        return achievementInfo
        
    }
    
}

class Ships {
    
    var shipsAPI: String!
    var ship_id: String!
    
    struct dataIndex {
        static let name = 0
        static let image = 1
        static let shipID = 2
        static let tier = 3
        static let type = 4
    }
    
    init(shipID: String) {
        ship_id = shipID
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        shipsAPI = "https://api.worldofwarships." + server + "/wows/encyclopedia/ships/?application_id=***ApplicationID***&ship_id=" + shipID + "&fields=default_profile.torpedoes.torpedo_speed%2Cdefault_profile.torpedoes.visibility_dist%2Cdefault_profile.torpedoes.max_damage%2Cdefault_profile.torpedoes.distance%2Cdefault_profile.torpedoes.reload_time%2Cdefault_profile.torpedoes.torpedo_name%2Cdefault_profile.mobility%2Cdefault_profile.concealment.detect_distance_by_plane%2Cdefault_profile.concealment.detect_distance_by_ship%2Cdefault_profile.artillery.slots.name%2Cdefault_profile.artillery.slots.guns%2Cdefault_profile.artillery.slots.barrels%2Cdefault_profile.artillery.distance%2Cdefault_profile.artillery.shot_delay%2Cdefault_profile.artillery.shells.bullet_speed%2Cdefault_profile.artillery.shells.burn_probability%2Cdefault_profile.artillery.shells.damage%2Cdefault_profile.artillery.shells.name%2Cdefault_profile.armour.flood_prob%2Cdefault_profile.armour.health%2Cis_premium%2Cdefault_profile.battle_level_range_max%2Cdefault_profile.battle_level_range_min%2Cnation%2Cdescription%2Cprice_credit%2Cprice_gold%2Ctype" + Language.getLanguageString()
    }
    
    func getShipJson(success: @escaping (JSON) -> ()) {
        
        let request = URLRequest(url: URL(string: shipsAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    success(dataJson["data"][self.ship_id])
                }
            }
        }
        task.resume()
        
    }
    
    static func getShipInformation(shipJson: JSON) -> [[String]] {
        
        var shipInfo = [[String]]()
        for ship in shipJson {
            shipInfo.append([ship.1["name"].stringValue, ship.1["images"]["small"].stringValue, ship.0, ship.1["tier"].stringValue, ship.1["type"].stringValue])
        }
        
        // Sort Achievement by tier
        shipInfo.sort(by: {Int($1[3])! < Int($0[3])!})
        return shipInfo
        
    }
    
}

class Upgrade {
    
    var upgradeAPI: String!
    static var upgradeJSON: JSON!
    
    struct dataIndex {
        static let name = 0
        static let description = 1
        static let image = 2
        static let price = 3
        static let id = 4
    }
    
    init() {
        // Setup achievementsAPI
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        upgradeAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/upgrades/?application_id=***ApplicationID***&fields=description%2Cname%2Cimage%2Cprice_credit" + Language.getLanguageString()
    }
    
    func getUpgradeJson() {
        
        let request = URLRequest(url: URL(string: upgradeAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    Upgrade.upgradeJSON = dataJson["data"]
                }
            }
        }
        task.resume()
        
    }
    
    static func getUpgradeInformation() -> [[String]] {
        
        var upgradeInfo = [[String]]()
        if Upgrade.upgradeJSON != nil {
            for upgrade in Upgrade.upgradeJSON {
                upgradeInfo.append([upgrade.1["name"].stringValue, upgrade.1["description"].stringValue, upgrade.1["image"].stringValue, upgrade.1["price_credit"].stringValue, upgrade.0])
            }
            print(upgradeInfo)
            
        }
        return upgradeInfo
        
    }
    
    
}

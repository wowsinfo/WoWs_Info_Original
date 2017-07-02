//
//  Achievements.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Achievements
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
        achievementsAPI = "https://api.worldofwarships." + server + "/wows/encyclopedia/achievements/?application_id=***ApplicationID***&fields=battle.name%2Cbattle.hidden%2Cbattle.description%2Cbattle.image%2Cbattle.image_inactive" + Language.getLanguageString(Mode: Language.Index.API)
    }
    
    func getAchievementJson() {
        
        let request = URLRequest(url: URL(string: achievementsAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
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

// MARKS: Ships
class Ships {
    
    var moduleAPI: String!
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
        shipsAPI = "https://api.worldofwarships." + server + "/wows/encyclopedia/ships/?application_id=***ApplicationID***&ship_id=" + shipID + "&fields=default_profile.torpedoes.torpedo_speed%2Cdefault_profile.torpedoes.visibility_dist%2Cdefault_profile.torpedoes.max_damage%2Cdefault_profile.torpedoes.distance%2Cdefault_profile.torpedoes.reload_time%2Cdefault_profile.torpedoes.torpedo_name%2Cdefault_profile.mobility%2Cdefault_profile.concealment.detect_distance_by_plane%2Cdefault_profile.concealment.detect_distance_by_ship%2Cdefault_profile.artillery.slots.name%2Cdefault_profile.artillery.slots.guns%2Cdefault_profile.artillery.slots.barrels%2Cdefault_profile.artillery.distance%2Cdefault_profile.artillery.shot_delay%2Cdefault_profile.artillery.shells.bullet_speed%2Cdefault_profile.artillery.shells.burn_probability%2Cdefault_profile.artillery.shells.damage%2Cdefault_profile.artillery.shells.name%2Cdefault_profile.armour.flood_prob%2Cdefault_profile.armour.health%2Cis_premium%2Cdefault_profile.battle_level_range_max%2Cdefault_profile.battle_level_range_min%2Cnation%2Cdescription%2Cprice_credit%2Cprice_gold%2Ctype" + Language.getLanguageString(Mode: Language.Index.API)
    }
    
    func getShipJson(success: @escaping (JSON) -> ()) {
        
        let request = URLRequest(url: URL(string: shipsAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
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

// MARK: Upgrade is the template for all the calss below
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
        upgradeAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/consumables/?application_id=***ApplicationID***&type=Modernization&fields=profile.description%2Cdescription%2Cprice_credit%2Cname%2Cimage" + Language.getLanguageString(Mode: Language.Index.API)
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
                var description = upgrade.1["description"].stringValue + "\n\n"
                
                for profile in upgrade.1["profile"] {
                    description += profile.1["description"].stringValue + "\n"
                }
                
                upgradeInfo.append([upgrade.1["name"].stringValue, description, upgrade.1["image"].stringValue, upgrade.1["price_credit"].stringValue, upgrade.0])
            }
            print(upgradeInfo)
            
        }
        return upgradeInfo
        
    }
    
}

class Flag {
    
    var flagAPI: String!
    static var flagJSON: JSON!
    
    init() {
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        flagAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/consumables/?application_id=***ApplicationID***&type=Flags&fields=profile.description%2Cdescription%2Cprice_gold%2Cname%2Cimage" + Language.getLanguageString(Mode: Language.Index.API)
    }
    
    
    func getFlagJson() {
        
        let request = URLRequest(url: URL(string: flagAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    Flag.flagJSON = dataJson["data"]
                }
            }
        }
        task.resume()
        
    }
    
    static func getFlagInformation() -> [[String]] {
        
        var flagInfo = [[String]]()
        if Flag.flagJSON != nil {
            for flag in Flag.flagJSON {
                var description = flag.1["description"].stringValue + "\n\n"
                
                for profile in flag.1["profile"] {
                    description += profile.1["description"].stringValue + "\n"
                }
                
                flagInfo.append([flag.1["name"].stringValue, description, flag.1["image"].stringValue, flag.1["price_gold"].stringValue, flag.0])
            }
            print(flagInfo)
            
        }
        flagInfo.sort(by: {Int($0[Upgrade.dataIndex.price])! < Int($1[Upgrade.dataIndex.price])!})
        return flagInfo
        
    }
    
}

class Camouflage {
    
    var camouflageAPI: String!
    static var camouflageJSON: JSON!
    
    static let price_credit = 5
    
    init() {
        // Setup achievementsAPI
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        camouflageAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/consumables/?application_id=***ApplicationID***\(Language.getLanguageString(Mode: Language.Index.API))&fields=profile.description%2Cdescription%2Cprice_credit%2Cname%2Cimage%2Ctype%2Cprice_gold"
    }
    
    func getCamouflageJson() {
        
        let request = URLRequest(url: URL(string: camouflageAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    Camouflage.camouflageJSON = dataJson["data"]
                }
            }
        }
        task.resume()
        
    }
    
    static func getCamouflageInformation() -> [[String]] {
        
        var camouflageInfo = [[String]]()
        if Camouflage.camouflageJSON != nil {
            for camouflage in Camouflage.camouflageJSON {
                if camouflage.1["type"].stringValue == "Permoflage" || camouflage.1["type"].stringValue == "Camouflage" {
                    var description = ""
                    
                    for profile in camouflage.1["profile"] {
                        description += profile.1["description"].stringValue + "\n"
                    }

                    camouflageInfo.append([camouflage.1["name"].stringValue, description, camouflage.1["image"].stringValue, camouflage.1["price_gold"].stringValue, camouflage.0, camouflage.1["price_credit"].stringValue])
                }
                print(camouflageInfo)
            }
        }
        camouflageInfo.sort(by: {Int($0[Upgrade.dataIndex.price])! < Int($1[Upgrade.dataIndex.price])!})
        
        return camouflageInfo
        
    }
    
}

class CommanderSkill {
    
    var commanderSkillAPI: String!
    static var commanderSkillJSON: JSON!
    
    static let tier = 5
    
    init() {
        // Setup achievementsAPI
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        commanderSkillAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/crewskills/?application_id=***ApplicationID***&fields=icon%2Cname%2Ctier%2Cperks.description%2Cperks.perk_id" + Language.getLanguageString(Mode: Language.Index.API)
    }
    
    func getCommanderSkillJson() {
        
        let request = URLRequest(url: URL(string: commanderSkillAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    CommanderSkill.commanderSkillJSON = dataJson["data"]
                }
            }
        }
        task.resume()
        
    }
    
    static func getCommanderSkillInformation() -> [[String]] {
        
        var commanderSkillInfo = [[String]]()
        if CommanderSkill.commanderSkillJSON != nil {
            for skill in CommanderSkill.commanderSkillJSON {
                var description = ""
                for perk in skill.1["perks"] {
                    description += perk.1["description"].stringValue + "\n"
                }
                commanderSkillInfo.append([skill.1["name"].stringValue, description, skill.1["icon"].stringValue, "", "", skill.1["tier"].stringValue])
            }
            print(commanderSkillInfo)
            commanderSkillInfo.sort(by: {$0[CommanderSkill.tier] < $1[CommanderSkill.tier]})
        }
        return commanderSkillInfo
        
    }
    
}

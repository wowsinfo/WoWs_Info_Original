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
        achievementsAPI = "https://api.worldofwarships." + server + "/wows/encyclopedia/achievements/?application_id=4e54ba74077a8230e457bf3e7e9ae858&fields=battle.name%2Cbattle.hidden%2Cbattle.description%2Cbattle.image%2Cbattle.image_inactive" + Language.getLanguageString(Mode: Language.Index.API)
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
    let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
    
    struct dataIndex {
        static let name = 0
        static let image = 1
        static let shipID = 2
        static let tier = 3
        static let type = 4
    }
    
    struct moduleIndex {
        static let hull = 0
        static let engine = 1
        static let torpedoes = 2
        static let fireControl = 3
        static let artillery = 4
        static let flightControl = 5
    }
    
    init(shipID: String) {
        ship_id = shipID
        // Get Module API and load basic information
        moduleAPI = "https://api.worldofwarships." + server + "/wows/encyclopedia/ships/?application_id=4e54ba74077a8230e457bf3e7e9ae858&ship_id=" + shipID + "&fields=is_premium%2Cdefault_profile.battle_level_range_max%2Cdefault_profile.battle_level_range_min%2Cnation%2Cdescription%2Cprice_credit%2Cprice_gold%2Ctype%2Cmodules_tree" + Language.getLanguageString(Mode: Language.Index.API)
    }
    
    // Get default information and module tree for future use
    func getBasicInformation(success: @escaping (JSON) -> ()) {
        let request = URLRequest(url: URL(string: moduleAPI)!)
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
    
    // Get module tree from Basic Information
    static func getModuleTree(data: JSON) -> [[[String]]] {
        // Six data only
        var moduleData = [[[String]]].init(repeating: [[String]](), count: 6)
        let data = data["modules_tree"]
        // Get all module and sort them by module index
        var index = 0
        for module in data {
            // Get its type
            switch module.1["type"].stringValue {
            case "Hull": index = 0
            case "Engine": index = 1
            case "Torpedoes": index = 2
            case "Suo": index = 3
            case "Artillery": index = 4
            case "FlightControl": index = 5
            default: continue // Does not care about other types
            }
            
            // Name, ID and module string
            moduleData[index].append([module.1["name"].stringValue, module.0, module.1["module_id_str"].stringValue])
        }
        
        for i in 0..<moduleData.count {
            // Index 2 is module_id_str
            moduleData[i].sort(by: {$0[2] < $1[2]})
        }
        
        return moduleData
    }
    
    func getUpdatedInformation(hull: String, engine: String, torpedoes: String, fireControl: String, artillery: String, flightControl: String, success: @escaping (JSON) -> ()) {
        // This is the ship parameter
        moduleAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/shipprofile/?application_id=4e54ba74077a8230e457bf3e7e9ae858&ship_id=\(ship_id!)&artillery_id=\(artillery)&engine_id=\(engine)&fire_control_id=\(fireControl)&torpedoes_id=\(torpedoes)&hull_id=\(hull)&flight_control_id=\(flightControl)&fields=-atbas%2C-dive_bomber%2C-fighters%2C-torpedo_bomber" + Language.getLanguageString(Mode: Language.Index.API)
        print(moduleAPI)
        
        let request = URLRequest(url: URL(string: moduleAPI)!)
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
        upgradeAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/consumables/?application_id=4e54ba74077a8230e457bf3e7e9ae858&type=Modernization&fields=profile.description%2Cdescription%2Cprice_credit%2Cname%2Cimage" + Language.getLanguageString(Mode: Language.Index.API)
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
        flagAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/consumables/?application_id=4e54ba74077a8230e457bf3e7e9ae858&type=Flags&fields=profile.description%2Cdescription%2Cprice_gold%2Cname%2Cimage" + Language.getLanguageString(Mode: Language.Index.API)
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
        camouflageAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/consumables/?application_id=4e54ba74077a8230e457bf3e7e9ae858\(Language.getLanguageString(Mode: Language.Index.API))&fields=profile.description%2Cdescription%2Cprice_credit%2Cname%2Cimage%2Ctype%2Cprice_gold"
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
        commanderSkillAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/crewskills/?application_id=4e54ba74077a8230e457bf3e7e9ae858&fields=icon%2Cname%2Ctier%2Cperks.description%2Cperks.perk_id" + Language.getLanguageString(Mode: Language.Index.API)
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

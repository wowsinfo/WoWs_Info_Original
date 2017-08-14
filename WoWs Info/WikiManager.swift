//
//  WikiManager.swift
//  WoWs Info
//
//  Created by Yiheng Quan on static 14/8/static let 7.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: The Main Class
class WikiManager: NSObject {
    var API = ""
    let Server = DataManager.getServerStringFrom(index: UserDefaults.getCurrServerIndex())
    let Language = String.getCurrLanguageString()
    let ApplicationID = DataManager.ApplicationID
    
    struct FileName {
        static let Achievements = "Achievements.json"
        static let Warships = "Warships.json"
        static let Upgrades = "Upgrades.json"
        static let Flags = "Flags.json"
        static let Camouflages = "Camouflages.json"
        static let CommanderSkills = "CommanderSkills.json"
        static let Collections = "Collections.json"
    }
    
    // Getting the lastest information from API
    static func updateDataFromAPI() {
        // Achievements, Warships, Flags, Camouflages, CommanderSkills, Collections
        Achievements().updateData()
        /*Warships().updateData()
        Upgrades().updateData()
        Flags().updateData()
        Camouflages().updateData()
        CommanderSkills().updateData()
        Collections().updateData()*/
    }
}

// MARK: Everything in WIKI
class Achievements: WikiManager {
    
    override init() {
        super.init()
        API = "https://api.worldofwarships.\(Server)/wows/encyclopedia/achievements/?application_id=\(ApplicationID)&fields=battle.description%2Cbattle.image%2Cbattle.image_inactive" + Language
    }
    
    func updateData() {
        // Update DATA and save LOCALLY
        if let APIUrl = URL(string: API) {
            let task = URLSession.shared.dataTask(with: URLRequest(url: APIUrl), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        // DATA is fine, Save dataJson["data"]["battle"]
                        FileManager.default.Save(Data: dataJson["data"]["battle"], Name: FileName.Achievements)
                    }
                }
            })
            task.resume()
        }
    }
    
}

class Warships: WikiManager {
    
    override init() {
        super.init()
        API = "https://api.worldofwarships.\(Server)/wows/encyclopedia/achievements/?application_id=\(ApplicationID)&fields=battle.description%2Cbattle.image%2Cbattle.image_inactive" + Language
    }
    
    func updateData() {
        // Update DATA and save LOCALLY
        if let APIUrl = URL(string: API) {
            let task = URLSession.shared.dataTask(with: URLRequest(url: APIUrl), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        // DATA is fine, Save dataJson["data"]["battle"]
                        FileManager.default.Save(Data: dataJson["data"]["battle"], Name: FileName.Achievements)
                    }
                }
            })
            task.resume()
        }
    }
    
}

class Upgrades: WikiManager {
    
    override init() {
        super.init()
        API = "https://api.worldofwarships.\(Server)/wows/encyclopedia/achievements/?application_id=\(ApplicationID)&fields=battle.description%2Cbattle.image%2Cbattle.image_inactive" + Language
    }
    
    func updateData() {
        // Update DATA and save LOCALLY
        if let APIUrl = URL(string: API) {
            let task = URLSession.shared.dataTask(with: URLRequest(url: APIUrl), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        // DATA is fine, Save dataJson["data"]["battle"]
                        FileManager.default.Save(Data: dataJson["data"]["battle"], Name: FileName.Achievements)
                    }
                }
            })
            task.resume()
        }
    }
    
}

class Flags: WikiManager {
    
    override init() {
        super.init()
        API = "https://api.worldofwarships.\(Server)/wows/encyclopedia/achievements/?application_id=\(ApplicationID)&fields=battle.description%2Cbattle.image%2Cbattle.image_inactive" + Language
    }
    
    func updateData() {
        // Update DATA and save LOCALLY
        if let APIUrl = URL(string: API) {
            let task = URLSession.shared.dataTask(with: URLRequest(url: APIUrl), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        // DATA is fine, Save dataJson["data"]["battle"]
                        FileManager.default.Save(Data: dataJson["data"]["battle"], Name: FileName.Achievements)
                    }
                }
            })
            task.resume()
        }
    }
    
}

class Camouflages: WikiManager {
    
    override init() {
        super.init()
        API = "https://api.worldofwarships.\(Server)/wows/encyclopedia/achievements/?application_id=\(ApplicationID)&fields=battle.description%2Cbattle.image%2Cbattle.image_inactive" + Language
    }
    
    func updateData() {
        // Update DATA and save LOCALLY
        if let APIUrl = URL(string: API) {
            let task = URLSession.shared.dataTask(with: URLRequest(url: APIUrl), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        // DATA is fine, Save dataJson["data"]["battle"]
                        FileManager.default.Save(Data: dataJson["data"]["battle"], Name: FileName.Achievements)
                    }
                }
            })
            task.resume()
        }
    }
}

class CommanderSkills: WikiManager {
    
    override init() {
        super.init()
        API = "https://api.worldofwarships.\(Server)/wows/encyclopedia/achievements/?application_id=\(ApplicationID)&fields=battle.description%2Cbattle.image%2Cbattle.image_inactive" + Language
    }
    
    func updateData() {
        // Update DATA and save LOCALLY
        if let APIUrl = URL(string: API) {
            let task = URLSession.shared.dataTask(with: URLRequest(url: APIUrl), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        // DATA is fine, Save dataJson["data"]["battle"]
                        FileManager.default.Save(Data: dataJson["data"]["battle"], Name: FileName.Achievements)
                    }
                }
            })
            task.resume()
        }
    }
}

class Collections: WikiManager {
    
    override init() {
        super.init()
        API = "https://api.worldofwarships.\(Server)/wows/encyclopedia/achievements/?application_id=\(ApplicationID)&fields=battle.description%2Cbattle.image%2Cbattle.image_inactive" + Language
    }
    
    func updateData() {
        // Update DATA and save LOCALLY
        if let APIUrl = URL(string: API) {
            let task = URLSession.shared.dataTask(with: URLRequest(url: APIUrl), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        // DATA is fine, Save dataJson["data"]["battle"]
                        FileManager.default.Save(Data: dataJson["data"]["battle"], Name: FileName.Achievements)
                    }
                }
            })
            task.resume()
        }
    }
}

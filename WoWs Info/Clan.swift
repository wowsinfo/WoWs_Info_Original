//
//  Clan.swift
//  WoWs Info
//
//  Created by Henry Quan on 24/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClanSearch {
    
    var clanAPI: String
    
    struct dataIndex {
        static let id = 0
        static let memberCount = 1
        static let name = 2
        static let tag = 3
    }
    
    init() {
        // Get server string
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        clanAPI = "https://api.worldofwarships.\(server)/wows/clans/list/?application_id=4e54ba74077a8230e457bf3e7e9ae858&search="
    }
    
    func getClanList(clan: String, success: @escaping ([[String]]) -> ()) {
        
        clanAPI += "\(clan)&fields=-created_at"
        let url = URL(string: clanAPI)
        if url != nil {
            let request = URLRequest(url: url!)
            
            // Get data
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (error != nil) {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    var clanInfo = [[String]]()
                    if dataJson["status"].stringValue == "ok" {
                        let count = dataJson["meta"]["count"].intValue
                        if count > 0 {
                            // If there is such clan
                            let clanDatajson = dataJson["data"]
                            
                            // Get all clan
                            for i in 0 ..< count {
                                clanInfo.append([clanDatajson[i]["clan_id"].stringValue, clanDatajson[i]["members_count"].stringValue, clanDatajson[i]["name"].stringValue, clanDatajson[i]["tag"].stringValue])
                            }
                        }
                    }
                    success(clanInfo)
                }
            }
            task.resume()
        }
    }
    
}

class ClanInfo {
    
    var clanAPI: String
    var clanID: String
    
    struct dataIndex {
        static let leader = 0
        static let description = 1
        static let name = 0
        static let id = 1
    }
    
    init(ID: String) {
        // Get server string
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        clanID = ID
        clanAPI = "https://api.worldofwarships.\(server)/wows/clans/info/?application_id=4e54ba74077a8230e457bf3e7e9ae858&clan_id=\(ID)&extra=members&fields=creator_name%2Cdescription%2Cmembers.account_id%2Cmembers.account_name"
        print(clanAPI)
    }
    
    func getClanList(success: @escaping ([[String]]) -> ()) {
        
        let request = URLRequest(url: URL(string: clanAPI)!)
        
        // Get data
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                print("dataJson: \(dataJson)")
                var clanInfo = [[String]]()
                if dataJson["status"].stringValue == "ok" {
                    // If data is valid
                    let clanDatajson = dataJson["data"]
                    print("clanDataJson: \(clanDatajson)")
                    // Add basic information
                    clanInfo.append([clanDatajson[self.clanID]["creator_name"].stringValue, clanDatajson[self.clanID]["description"].stringValue])
                    
                    // Get all member
                    for member in clanDatajson[self.clanID]["members"] {
                        clanInfo.append([member.1["account_name"].stringValue, member.1["account_id"].stringValue])
                    }
                }
                success(clanInfo)
            }
        }
        task.resume()
        
    }
    
}

class PlayerClan {
    
    var clanAPI: String
    var PlayerID: String
    
    struct dataIndex {
        static let clan = 0
        static let tag = 1
    }
    
    init() {
        // Get server string
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        PlayerID = PlayerAccount.AccountID
        clanAPI = "https://api.worldofwarships.\(server)/wows/clans/accountinfo/?application_id=4e54ba74077a8230e457bf3e7e9ae858&account_id=\(PlayerID)&extra=clan&fields=clan_id%2Cclan.tag"
    }
    
    func getClanList(success: @escaping ([String]) -> ()) {
        
        let request = URLRequest(url: URL(string: clanAPI)!)
        
        // Get data
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                print("dataJson: \(dataJson)")
                var clanInfo = [String]()
                if dataJson["status"].stringValue == "ok" {
                    // If data is valid
                    let clanDatajson = dataJson["data"]
                    // If there is a clan
                    if clanDatajson[self.PlayerID] != JSON.null {
                        clanInfo.append(clanDatajson[self.PlayerID]["clan_id"].stringValue)
                        clanInfo.append(clanDatajson[self.PlayerID]["clan"]["tag"].stringValue)
                    }
                }
                success(clanInfo)
            }
        }
        task.resume()
        
    }
}

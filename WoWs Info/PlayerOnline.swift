//
//  PlayerOnline.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class PlayerOnline {
    
    var playerOnlineAPI: String
    
    init() {
        let server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        
        playerOnlineAPI = "https://api.worldoftanks.\(ServerUrl.Server[server])/wgn/servers/info/?application_id=demo"
    }
    
    func getOnlinePlayerNumber(success: @escaping (String) -> ()){
        
        let request = URLRequest(url: URL(string: playerOnlineAPI)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            if (error != nil) {
                print("Error : \(error)")
            } else {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                        let dataJson = json["data"] as AnyObject
                        let wowsJson = dataJson["wows"] as! NSArray
                        
                        let online = wowsJson[0] as AnyObject
                        let playerOnline = online["players_online"] as! Int
                        success("\(playerOnline)")
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }
                }
            }
        }
        task.resume()
    }

}

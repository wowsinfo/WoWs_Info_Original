//
//  PlayerOnline.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlayerOnline {
    
    var playerOnlineAPI: String
    
    init() {
        let server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        
        playerOnlineAPI = "https://api.worldoftanks.\(ServerUrl.Server[server])/wgn/servers/info/?application_id=4e54ba74077a8230e457bf3e7e9ae858"
    }
    
    func getOnlinePlayerNumber(success: @escaping (String) -> ()){
        
        let request = URLRequest(url: URL(string: playerOnlineAPI)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            if (error != nil) {
                print("Error : \(error)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    // Get online player number
                    let playerOnline = dataJson["data"]["wows"][0]["players_online"].intValue
                    success("\(playerOnline)")
                }
            }
        }
        task.resume()
    }

}

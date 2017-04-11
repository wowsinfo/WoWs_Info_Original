//
//  PlayerInformation.swift
//  WoWs Info
//
//  Created by Henry Quan on 1/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlayerInfomation {
    
    // {{Name, ID}, {Name, ID}, {Name, ID}, {Name, ID}}
    var playerInfo = [[String]]()
    
    // API url to search player
    var server = ""
    let applicationID = "***ApplicationID***"
    var playerSearchAPI = ""
    
    // Search limit bt default is 15
    var searchLimit = 15
    
    init(limit: Int) {
        
        // Get server domain
        let serverIndex = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        server = ServerUrl(serverIndex: serverIndex).getServerDomain()
        
        // Get player search api
        playerSearchAPI = "https://api.worldofwarships.\(server)/wows/account/list/?application_id=\(applicationID)"
        
        // Set up limit and request
        searchLimit = limit

    }
    
    // MARK: useful functions
    func isInputValid(input: String) -> Bool {
        
        // At least 3 character. Whitespace is not counted
        return input.replacingOccurrences(of: " ", with: "").characters.count >= 3
        
    }
    
    func getDataFromAPI(search: String, success: @escaping ([[String]]) -> ()){
        
        // Make post data according to user input
        let searchNoSpace = search.replacingOccurrences(of: " ", with: "")
        
        playerSearchAPI += "&search=\(searchNoSpace)&language=en&limit=\(searchLimit)"
        let url = URL(string: playerSearchAPI)
        if url != nil {
            let request = URLRequest(url: url!)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (error != nil) {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        let count = dataJson["meta"]["count"].intValue
                        var player = [[String]]()
                        
                        if count > 0 {
                            for i in 0...(count - 1) {
                                // Add name and ID into array
                                let nickname = dataJson["data"][i]["nickname"].stringValue
                                let account = dataJson["data"][i]["account_id"].stringValue
                                print(nickname, account)
                                player.append([nickname, account])
                            }
                        }
                        success(player)
                    }
                }
            }
            task.resume()
        }
    }
    
}

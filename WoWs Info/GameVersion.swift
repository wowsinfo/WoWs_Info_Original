//
//  GameVersion.swift
//  WoWs Info
//
//  Created by Yiheng Quan on 13/8/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameVersion: DataManager {
    
    var VersionAPI = ""
    
    override init() {
        // Setup API url
        super.init()
        let serverIndex = UserDefaults.getCurrServerIndex()
        VersionAPI = "https://api.worldofwarships.\(DataManager.getServerStringFrom(index: serverIndex))/wows/encyclopedia/info/?application_id=\(ApplicationID)&fields=game_version&language=en"
    }
    
    func getCurrVersion(Version: @escaping (String) -> ()) {
        // Check if URL is valid
        if let api = URL(string: VersionAPI) {
            // Make a request
            let request = URLRequest(url: api)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if (error != nil) {
                    // Checking for Error
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        // API is OK
                        let currVersion = dataJson["data"]["game_version"].stringValue
                        print("Current Version is \(currVersion)")
                        Version(currVersion)
                    }
                }
            })
            task.resume()
        }
    }

}

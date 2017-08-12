//
//  ServerStatus.swift
//  WoWs Info
//
//  Created by Henry Quan on 21/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServerStatus: NSObject {
    
    static func getServerVersion(success: @escaping ((String) -> Void)) {
        // Get current server
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        if let url = URL(string: "https://api.worldofwarships.\(server)/wows/encyclopedia/info/?application_id=***ApplicationID***&fields=game_version" + Language.getLanguageString(Mode: Language.Index.API)) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    let dataJson = JSON(data!)
                    if dataJson["status"].stringValue == "ok" {
                        success(dataJson["data"]["game_version"].stringValue)
                    }
                }
            }
            task.resume()
        }
    }
    
    static func getPlayerOnline(success: @escaping ([String]) -> Void) {
        var serverStatus = [String]()
        
        // NA
        let request = URLRequest(url: URL(string: "https://api.worldoftanks.com/wgn/servers/info/?application_id=***ApplicationID***")!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    serverStatus.append(dataJson["data"]["wows"][0]["players_online"].stringValue)
                    // EU
                    let request = URLRequest(url: URL(string: "https://api.worldoftanks.eu/wgn/servers/info/?application_id=***ApplicationID***")!)
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if error != nil {
                            print("Error: \(error!)")
                        } else {
                            let dataJson = JSON(data!)
                            if dataJson["status"].stringValue == "ok" {
                                serverStatus.append(dataJson["data"]["wows"][0]["players_online"].stringValue)
                                // RU
                                let request = URLRequest(url: URL(string: "https://api.worldoftanks.ru/wgn/servers/info/?application_id=***ApplicationID***")!)
                                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                                    if error != nil {
                                        print("Error: \(error!)")
                                    } else {
                                        let dataJson = JSON(data!)
                                        if dataJson["status"].stringValue == "ok" {
                                            serverStatus.append(dataJson["data"]["wows"][0]["players_online"].stringValue)
                                            // ASIA
                                            let request = URLRequest(url: URL(string: "https://api.worldoftanks.asia/wgn/servers/info/?application_id=***ApplicationID***")!)
                                            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                                                if error != nil {
                                                    print("Error: \(error!)")
                                                } else {
                                                    let dataJson = JSON(data!)
                                                    if dataJson["status"].stringValue == "ok" {
                                                        serverStatus.append(dataJson["data"]["wows"][0]["players_online"].stringValue)
                                                        success(serverStatus)
                                                    }
                                                }
                                            }
                                            task.resume()
                                        }
                                    }
                                }
                                task.resume()
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        task.resume()
        
    }

}

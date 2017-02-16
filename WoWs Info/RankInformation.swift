//
//  RankInformation.swift
//  WoWs Info
//
//  Created by Henry Quan on 15/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class RankInformation{

    var AccountID = ""
    let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
    var RankAPI = ""
    
    struct RankDataIndex {
        static let battles = 0
        static let winRate = 1
        static let damage = 2
        static let currentRank = 3
        static let maxRank = 4
        static let season = 5
    }
    
    init(ID: String) {
        AccountID = ID
        RankAPI = "https://api.worldofwarships.\(server)/wows/seasons/accountinfo/?application_id=4e54ba74077a8230e457bf3e7e9ae858&account_id=\(ID)&fields=seasons.rank_solo.battles%2C+seasons.rank_solo.wins%2C+seasons.rank_info.rank%2c+seasons.rank_info.max_rank%2C+seasons.rank_solo.damage_dealt"
    }
    
    func getRankInformation(success: @escaping ([[String]]) -> ()) {
        
        let request = URLRequest.init(url: URL(string: RankAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    let rankJson = dataJson["data"][self.AccountID]["seasons"]
                    
                    var rank = [[String]]()
                    let sortedJson = rankJson.sorted(by: {$1.0 < $0.0})
                    
                    for season in sortedJson {
                        // Create enough space for all data
                        var damage = "0"
                        var wins = "0"
                        var battles = "0"
             
                        let currentRank = season.1["rank_info"]["rank"].stringValue
                        let maxRank = season.1["rank_info"]["max_rank"].stringValue
                        
                        let rank_solo = season.1["rank_solo"]

                        if rank_solo != JSON.null {
                            damage = rank_solo["damage_dealt"].stringValue
                            wins = rank_solo["wins"].stringValue
                            battles = rank_solo["battles"].stringValue
                        }
                        
                        if battles != "0" {
                            var info = self.calculateRankInformation(Battles: battles, Wins: wins, Damage: damage)
                            info += [currentRank, maxRank, season.0]
                            
                            rank.append(info)
                        }
                        
                    }
                    print(rank)
                    success(rank)
                    
                }
            }
        }
        task.resume()
        
    }
    
    func calculateRankInformation(Battles: String, Wins: String, Damage: String) -> [String] {
        
        var data = [Battles,"0","0"]
        
        let battles = Double(Battles)!
        let wins = Double(Wins)!
        let damage = Double(Damage)!
        
        if battles > 0.0 {
            let winRate = "\(Double(round(100 * (wins / battles * 100)) / 100))%"
            let averageDamage = String(format: "%.0f", Double(round(damage / battles)))
            data[1] = winRate
            data[2] = averageDamage
        }
        
        return data
        
    }
    
}

//
//  ShipInformation.swift
//  WoWs Info
//
//  Created by Henry Quan on 15/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Shipinformation {
    
    let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
    var shipInfoAPI = ""
    static var ShipJson: (JSON!)

    init() {
        shipInfoAPI = "https://api.worldofwarships.\(server)/wows/encyclopedia/ships/?application_id=4e54ba74077a8230e457bf3e7e9ae858&fields=name%2Ctype%2Ctier%2Cnation%2Cimages.small" + Language.getLanguageString()
    }
    
    func getShipInformation() {
        
        // Get all ship information here
        let request = URLRequest.init(url: URL(string: shipInfoAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    // Get Information for all ships
                    Shipinformation.ShipJson = dataJson["data"]
                }
            }
        }
        task.resume()
        
    }
    
    static func getImageWithId(ID: String, Success: @escaping (String) -> ()) {
        
        // Get all ship information here
        let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
        let request = URLRequest.init(url: URL(string: "https://api.worldofwarships.\(server)/wows/encyclopedia/ships/?application_id=4e54ba74077a8230e457bf3e7e9ae858&fields=images.small&ship_id=" + ID)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    // Get Information for all ships
                    Success(dataJson["data"][ID]["images"]["small"].stringValue)
                }
            }
        }
        task.resume()
        
    }
    
    static func getImageWithType(type: String) -> UIImage {
        
        switch type {
            case "Destroyer":
                return #imageLiteral(resourceName: "Destroyer")
            case "Cruiser":
                return #imageLiteral(resourceName: "Cruiser")
            case "Battleship":
                return #imageLiteral(resourceName: "Battleship")
            case "AirCarrier":
                return #imageLiteral(resourceName: "Aircraft Carrier")
            default:
                return #imageLiteral(resourceName: "Icon")
        }
        
    }
    
}

class PlayerShip {
    
    let server = ServerUrl.Server[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)]
    var playerShipsAPI = ""
    var playerAccount = ""
    
    static var playerShipInfo = [[String]]()
    
    // In case I get wrong data
    struct PlayerShipDataIndex {
        static let battles = 0
        static let winRate = 1
        static let averageDamage = 2
        static let averageExp = 3
        static let killDeathRatio = 4
        static let tier = 5
        static let type = 6
        static let hitRatio = 7
        static let averageFrags = 8
        static let name = 9
        static let rating = 10
        static let totalDamage = 11
        static let totalFrags = 12
        static let totalWins = 13
        static let id = 14
    }
    
    init(account: String) {
        playerAccount = account
        playerShipsAPI = "https://api.worldofwarships.\(server)/wows/ships/stats/?application_id=4e54ba74077a8230e457bf3e7e9ae858&account_id=\(account)&fields=ship_id%2Cpvp.battles%2Cpvp.damage_dealt%2Cpvp.wins%2Cpvp.xp%2Cpvp.frags%2Cpvp.survived_battles%2Cpvp.main_battery.hits%2Cpvp.main_battery.shots"
    }
    
    func getPlayerShipInfo() {
        
        let request = URLRequest.init(url: URL(string: playerShipsAPI)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                let dataJson = JSON(data!)
                if dataJson["status"].stringValue == "ok" {
                    let shipJson = dataJson["data"]
                    var shipInfo = [[String]]()
                    for ship in shipJson[self.playerAccount] {
                        // Get all ship information
                        let pvpJson = ship.1["pvp"]
                        var information = [String]()
                        
                        let battles = pvpJson["battles"].doubleValue
                        // Have to play at least once
                        if battles > 0.0 {
                            let wins = pvpJson["wins"].doubleValue
                            let xp = pvpJson["xp"].doubleValue
                            let frags = pvpJson["frags"].doubleValue
                            let survived_battles = pvpJson["survived_battles"].doubleValue
                            let damage = pvpJson["damage_dealt"].doubleValue
                            
                            let hits = pvpJson["main_battery"]["hits"].doubleValue
                            let shots = pvpJson["main_battery"]["shots"].doubleValue
                            
                            information = PlayerStat.calculateStatisticsWithData(battles: battles, xp: xp, wins: wins, frags: frags, damage: damage, survived: survived_battles, hits: hits, shots: shots)
                            // Default value for tier type and name
                            let shipID = ship.1["ship_id"].stringValue
                            information[PlayerShip.PlayerShipDataIndex.tier] = ""
                            information[PlayerShip.PlayerShipDataIndex.type] = ""
                            information.append(shipID)
                            
                            information[PlayerShip.PlayerShipDataIndex.totalDamage] = "\(damage)"
                            information[PlayerShip.PlayerShipDataIndex.totalWins] = "\(wins)"
                            information[PlayerShip.PlayerShipDataIndex.totalFrags] = "\(frags)"
                            
                            // Get ship information
                            if Shipinformation.ShipJson != nil {
                                let ship = Shipinformation.ShipJson[shipID]
                                if ship != JSON.null {
                                    // If there is such ID
                                    information[PlayerShip.PlayerShipDataIndex.tier] = ship["tier"].stringValue
                                    information[PlayerShip.PlayerShipDataIndex.type] = ship["type"].stringValue
                                    information[PlayerShip.PlayerShipDataIndex.name] = ship["name"].stringValue
                                    
                                    let ratingIndex = ShipRating().getRatingForShips(Damage: damage/battles, WinRate: wins/battles, Frags: frags/battles, ID: shipID)
                                    information[PlayerShip.PlayerShipDataIndex.rating] = ratingIndex
                                    
                                    // Only add new ships
                                    shipInfo.append(information)
                                }
                            }
                        }
                    }

                    // Sort array
                    shipInfo.sort(by: {
                        // If they have same rating
                        if Int($0[10].components(separatedBy: "|")[1])! == Int($1[10].components(separatedBy: "|")[1])! {
                            return Int($0[5])! > Int($1[5])!
                        }
                        return Int($0[10].components(separatedBy: "|")[1])! > Int($1[10].components(separatedBy: "|")[1])!
                    })
                    
                    PlayerShip.playerShipInfo = shipInfo
                    
                    print(shipInfo)
                }
            }
        }
        task.resume()
    }
}

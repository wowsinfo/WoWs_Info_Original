//
//  Charts.swift
//  WoWs Info
//
//  Created by Henry Quan on 19/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class Charts {
    
    var shipData = [[String]]()
    
    init(data: [[String]]) {
        shipData = data
    }
    
    // Index for ship types
    struct shipTypeIndex {
        static let dd = 0
        static let ca = 1
        static let bb = 2
        static let cv = 3
    }
    
    // Get tier data
    func getTierInformation() -> [Int] {
        var tier = [0,0,0,0,0,0,0,0,0,0]
        for ship in shipData {
            // Get ship tier and add one to tier
            let shipTier = ship[PlayerShip.PlayerShipDataIndex.tier]
            // There are some ships that do not have tier information
            if shipTier != "" {
                tier[Int(shipTier)!] += 1
            }
        }
        return tier
    }
    
    // Get Ship type
    func getShipTypeInformation() -> [Int] {
        var type = [0,0,0,0]
        for ship in shipData {
            let shipType = ship[PlayerShip.PlayerShipDataIndex.type]
            // For those ship that does not have a type, just break
            switch shipType {
                case "Destroyer":
                    type[0] += 1
                case "Cruiser":
                    type[1] += 1
                case "Battleship":
                    type[2] += 1
                case "AirCarrier":
                    type[3] += 1
                default:
                break
            }
        }
        return type
    }
    
    // Get most played 5 ships
    func getMostPlayedShipInformation() -> ([Int], [String]) {
        if shipData.count >= 5 {
            var battlesCount = [0,0,0,0,0]
            var shipName = ["","","","",""]
            
            for i in 0...4 {
                for ship in shipData {
                    let name = ship[PlayerShip.PlayerShipDataIndex.name]
                    let battles = Int(ship[PlayerShip.PlayerShipDataIndex.battles])!
                    
                    if battles > battlesCount[i] {
                        if i > 0 {
                            // Check with previous
                            if battles < battlesCount[i - 1] {
                                battlesCount[i] = battles
                                shipName[i] = name
                            }
                        } else {
                            // First one is always the biggest
                            battlesCount[i] = battles
                            shipName[i] = name
                        }
                    }
                }
            }
            return (battlesCount, shipName)
        } else {
            // return nothing
            return ([Int](), [String]())
        }
    }
}

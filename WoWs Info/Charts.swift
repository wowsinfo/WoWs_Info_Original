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
            let shipTier = Int(ship[PlayerShip.PlayerShipDataIndex.tier])! - 1
            let battles = Int(ship[PlayerShip.PlayerShipDataIndex.battles])!
            tier[shipTier] += battles
        }
        return tier
    }
    
    // Get Ship type
    func getShipTypeInformation() -> [Int] {
        var type = [0,0,0,0]
        for ship in shipData {
            let shipType = ship[PlayerShip.PlayerShipDataIndex.type]
            let battles = Int(ship[PlayerShip.PlayerShipDataIndex.battles])!
            // For those ship that does not have a type, just break
            switch shipType {
                case "Destroyer":
                    type[0] += battles
                case "Cruiser":
                    type[1] += battles
                case "Battleship":
                    type[2] += battles
                case "AirCarrier":
                    type[3] += battles
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
            
            let sortByBattle = shipData.sorted(by: {Int($1[0])! < Int($0[0])!})
            for i in 0...4 {
                battlesCount[i] = Int(sortByBattle[i][0])!
                shipName[i] = sortByBattle[i][9]
            }
            
            print(shipName)
            
            return (battlesCount, shipName)
        } else {
            // return nothing
            return ([Int](), [String]())
        }
    }
}

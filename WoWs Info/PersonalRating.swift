//
//  StatAnalysis.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class PersonalRating {
    
    // Show different color according to different numbers
    struct ColorIndex {
        static let Bad = 0
        static let BelowAverage = 1
        static let Average = 2
        static let Good = 3
        static let VeryGood = 4
        static let Great = 5
        static let Unicum = 6
        static let SuperUnicum = 7
    }
    
    static let Comment = ["*>_<*", "Below Average", "Average", "Good", "Very Good", "Great", "Unicum", "SUPER Unicum"]
    
    // Colour Group
    static let ColorGroup = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.init(red: 0, green: 158/255, blue: 57/255, alpha: 1.0), UIColor.cyan, UIColor.magenta, UIColor.purple]
    
    var damage = 0.0
    var winrate = 0.0
    var frags = 0.0
    var PR = 0.0
    
    init(Damage: String, WinRate: String, Frags: String) {
        
        damage = Double(Damage)!
        winrate = Double(WinRate.replacingOccurrences(of: "%", with: ""))!
        frags = Double(Frags)!
        
        let rDmg = damage/36500
        let rWins = winrate/51.5
        let rFrags = frags/0.85
        
        let nDmg = max(0, (rDmg - 0.4) / (1 - 0.4))
        let nFrags = max(0, (rFrags - 0.1) / (1 - 0.1))
        let nWins = max(0, (rWins - 0.7) / (1 - 0.7))
        
        PR = 700 * nDmg + 300 * nFrags + 150 * nWins - 25
        
    }
    
    func getPersonalRatingIndex() -> Int {
        
        switch PR {
        case let pr where pr < 750:
            return 0
        case let pr where pr < 1100:
            return 1
        case let pr where pr < 1350:
            return 2
        case let pr where pr < 1550:
            return 3
        case let pr where pr < 1750:
            return 4
        case let pr where pr < 2100:
            return 5
        case let pr where pr < 2450:
            return 6
        case let pr where pr >= 2450:
            return 7
        default:
            return 0
        }
        
    }
    
}

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
    
    static let ColorGroup = [UIColor.red, UIColor.orange, UIColor.blue, UIColor.purple, UIColor.brown, UIColor.black]
    
    var battle = 0
    var damage = 0
    var winrate = 0
    var frags = 0
    
    init(Battles: String, Damage: String, WinRate: String, Frags: String) {
        
        battle = Int(Battles)!
        damage = Int(Damage)!
        winrate = Int(WinRate)!
        frags = Int(Frags)!
        
    }
    
}

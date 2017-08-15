//
//  UIColor+RGB.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: Get colour from RGB
    static func RGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    // MARK: Personal Rating Colours
    static func ImprovementNeeded() -> UIColor {
        return UIColor.red
    }
    
    static func BelowAverage() -> UIColor {
        return UIColor.orange
    }
    
    static func Average() -> UIColor {
        return UIColor.RGB(red: 255, green: 199, blue: 31)
    }
    
    static func Good() -> UIColor {
        return UIColor.green
    }
    
    static func VeryGood() -> UIColor {
        return UIColor.RGB(red: 0, green: 158, blue: 57)
    }
    
    static func Great() -> UIColor {
        return UIColor.cyan
    }
    
    static func Unicum() -> UIColor {
        return UIColor.magenta
    }
    
    static func SuperUnicum() -> UIColor {
        return UIColor.purple
    }
    
    // MARK: Personal Rating Colour Group
    static func PRColourGroup() -> [UIColor] {
        return [UIColor.ImprovementNeeded(), UIColor.BelowAverage(), UIColor.Average(), UIColor.Good(), UIColor.VeryGood(), UIColor.Great(), UIColor.Unicum(), UIColor.SuperUnicum()]
    }
    
    // MARK: Theme Colour Group
    static func ThemeColourGroup() -> [UIColor] {
        return [UIColor.RGB(red: 68, green: 192, blue: 255), // Blue
                UIColor.RGB(red: 49, green: 153, blue: 218),
                UIColor.RGB(red: 85, green: 163, blue: 255),
                UIColor.RGB(red: 10, green: 86, blue: 143),
                
                UIColor.RGB(red: 242, green: 71, blue: 56), // Red
                UIColor.RGB(red: 255, green: 109, blue: 107),
                UIColor.RGB(red: 231, green: 75, blue: 61),
                UIColor.RGB(red: 191, green: 86, blue: 135),
                
                UIColor.RGB(red: 63, green: 145, blue: 76), // Green
                UIColor.RGB(red: 44, green: 204, blue: 114),
                UIColor.RGB(red: 43, green: 105, blue: 80),
                
                UIColor.RGB(red: 45, green: 255, blue: 255), // Cyan
                
                UIColor.RGB(red: 163, green: 107, blue: 242),// Purple
                UIColor.RGB(red: 194, green: 122, blue: 210),
                UIColor.RGB(red: 109, green: 116, blue: 242),
                
                UIColor.RGB(red: 171, green: 119, blue: 84), // Brown
                UIColor.RGB(red: 201, green: 161, blue: 134),
                
                UIColor.RGB(red: 255, green: 220, blue: 45), // Yellow
                
                UIColor.RGB(red: 242, green: 145, blue: 61), // Orange
                UIColor.RGB(red: 254, green: 152, blue: 58),
                
                UIColor.RGB(red: 57, green: 57, blue: 62), // Black
                UIColor.RGB(red: 150, green: 164, blue: 166)]
    }
    
    static func getCurrTheme() -> UIColor {
        return UserDefaults.standard.color(forKey: DataManager.DataName.theme)!
    }
    
}

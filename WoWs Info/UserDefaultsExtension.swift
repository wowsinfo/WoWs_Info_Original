//
//  UserDefaults+UIColor.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

extension UserDefaults {
    // MARK: Get and Save Colour
    func set(_ color: UIColor, forKey key: String) {
        set(NSKeyedArchiver.archivedData(withRootObject: color), forKey: key)
    }
    
    func color(forKey key: String) -> UIColor? {
        guard let data = data(forKey: key) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
    }
    
    // MARK: Get and Set String value
    static func getData(withName: String) -> Any {
        return UserDefaults.standard.object(forKey: withName)!
    }
    
    // MARK: Some Serveral Useful Quick Functions
    static func getCurrServerIndex() -> Int {
        return self.standard.integer(forKey: DataManager.DataName.Server)
    }
    
    static func getCurrVersion() -> String {
        return self.standard.string(forKey: DataManager.DataName.GameVersion)!
    }
    
    static func isPro() -> Bool {
        return self.standard.bool(forKey: DataManager.DataName.hasPurchased)
    }
}


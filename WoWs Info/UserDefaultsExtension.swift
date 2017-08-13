//
//  UserDefaults+UIColor.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

extension UserDefaults {
    func set(_ color: UIColor, forKey key: String) {
        set(NSKeyedArchiver.archivedData(withRootObject: color), forKey: key)
    }
    
    func color(forKey key: String) -> UIColor? {
        guard let data = data(forKey: key) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
    }
}


//
//  Theme.swift
//  WoWs Info
//
//  Created by Henry Quan on 28/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class Theme: NSObject {
    static func getCurrTheme() -> UIColor {
        return UserDefaults.standard.color(forKey: DataManagement.DataName.theme) ?? UIColor.blue
    }
}

//
//  UIColor+RGB.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func RGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
}

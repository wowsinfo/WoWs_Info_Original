//
//  DateExtension.swift
//  WoWs Info
//
//  Created by Yiheng Quan on 13/8/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

extension Date {
    // MARK: Getting Today's String -> 15/08/2017
    static func getCurrentDateString() -> String {
        let today = Date()
        let formatter = DateFormatter()
        // This is like Aug 15, 2017
        formatter.dateStyle = .medium
        let todayString = formatter.string(from: today)
        print("Date  is \(todayString)")
        
        return todayString
    }
    
    // MARK: Checking if it is a new day
    static func isNewDay() -> Bool {
        let day = self.getCurrentDateString()
        if day != UserDefaults.getTodayString() {
            print("Today is \(day)")
            UserDefaults.standard.set(day, forKey: DataManager.DataName.Today)
            return true
        }
        return false
    }
    
    // MARK: Checking if it has been 10 days
    static func isTenDayLater() -> Bool {
        return false
    }
}

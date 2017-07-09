//
//  PointSystem.swift
//  WoWs Info
//
//  Created by Henry Quan on 9/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class PointSystem: NSObject {
    
    var index = 0
    
    struct DataIndex {
        static let AD = 0
        static let Review = 1
        static let Share = 2
    }
    
    init(index: Int) {
        self.index = index
    }
    
    func addPoint() {
        if isPro() { return }
        // Add point
        let currPoint = PointSystem.getCurrPoint()
        UserDefaults.standard.set(currPoint + getAmoutFromIndex(index: self.index), forKey: DataManagement.DataName.pointSystem)
    }
    
    func isPro() -> Bool {
        return UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased)
    }
    
    static func getCurrPoint() -> Int {
        return UserDefaults.standard.integer(forKey: DataManagement.DataName.pointSystem)
    }
    
    func getAmoutFromIndex(index: Int) -> Int {
        switch index {
        case 0: return 3
        case 1: return 30
        case 2: return 50
        default: return 0
        }
    }
    
}

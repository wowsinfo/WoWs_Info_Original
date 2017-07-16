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
    var pointToRemove = 0
    
    struct DataIndex {
        static let AD = 0
        static let Review = 1
        static let Share = 2
        static let NotReady = 3
    }
    
    init(index: Int) {
        self.index = index
    }
    
    init(pointToRemove: Int) {
        self.pointToRemove = pointToRemove
    }
    
    // MARK: Add / Remove Pints
    func addPoint() {
        if isPro() { return }
        // Add point
        switch index {
        case 0: break
        case 1:
            if hasReview() { return }
        case 2:
            if hasShare() { return }
        case 3: break
        default: return
        }
        
        let currPoint = PointSystem.getCurrPoint()
        UserDefaults.standard.set(currPoint + getAmoutFromIndex(index: self.index), forKey: DataManagement.DataName.pointSystem)
    }
    
    func removePoint() {
        if isPro() { return }
        let currPoint = PointSystem.getCurrPoint()
        UserDefaults.standard.set(currPoint - pointToRemove, forKey: DataManagement.DataName.pointSystem)
    }
    
    // MARK: Helper Functions
    func isPro() -> Bool {
        return UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased)
    }
    
    func hasReview() -> Bool {
        return UserDefaults.standard.bool(forKey: DataManagement.DataName.didReview)
    }
    
    func hasShare() -> Bool {
        return UserDefaults.standard.bool(forKey: DataManagement.DataName.didShare)
    }
    
    static func getCurrPoint() -> Int {
        return UserDefaults.standard.integer(forKey: DataManagement.DataName.pointSystem)
    }
    
    func getAmoutFromIndex(index: Int) -> Int {
        switch index {
        case 0: return Int(arc4random() % 5 + 3)
        case 1: return Int(arc4random() % 26 + 50)
        case 2: return Int(arc4random() % 26 + 50)
        case 3: return 1
        default: return 0
        }
    }
    
}

//
//  DataIndex.swift
//  WoWs Info
//
//  Created by Yiheng Quan on 13/8/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

// Deal with API, Index
class DataManager: NSObject {
    
    var API = ""
    let Server = DataManager.getServerStringFrom(index: UserDefaults.getCurrServerIndex())
    let Language = String.getCurrLanguageString()
    let ApplicationID = "4e54ba74077a8230e457bf3e7e9ae858"
    
    // MARK: 4 servers
    struct ServerIndex {
        static let Russia = 0
        static let Europe = 1
        static let NorthAmercia = 2
        static let Asia = 3
    }
    
    // MARK: Get Server String From Index
    static func getServerStringFrom(index: Int) -> String {
        let ServerGroup = ["ru", "eu", "com", "asia"]
        return ServerGroup[index]
    }
    
    // MARK: For all saved data name
    struct DataName {
        // Old data names
        static let FirstLaunch = "first_launch"
        static let SearchLimit = "search_limit"
        static let Server = "server"
        static let hasPurchased = "hasPurchased"
        static let friend = "friend_list"
        static let theme = "theme"
        static let didReview = "review"
        static let didShare = "share"
        static let gotoGithub = "github"
        static let pointSystem = "point_system"
        // Some new names
        static let GameVersion = "game_version"
        static let Today = "today" // 5 - 7 points everyday
        static let Language = "language"
        static let AccessToken = "access_token"
    }
    
    // MARK: Setup UserDefaults
    static func setupDataForNew() {
        // For a completely new user. Just setup
        let new = UserDefaults.standard
        
        new.set(true, forKey: DataName.FirstLaunch)
        new.set(50, forKey: DataName.SearchLimit)
        new.set(3, forKey: DataName.Server)
        new.set(false, forKey: DataName.hasPurchased)
        // Blue by default
        new.set(UIColor.RGB(red: 85, green: 163, blue: 255), forKey: DataName.theme)
        new.set(false, forKey: DataName.didShare)
        new.set(false, forKey: DataName.didReview)
        new.set(false, forKey: DataName.gotoGithub)
        // 20 points by default
        new.set(20, forKey: DataName.pointSystem)
    }
    
    // MARK: Adding new data to UserDefaults
    static func setupAdditionData() {
        let extraData = UserDefaults.standard
        
        extraData.set(String.getCurrLanguageString(), forKey: DataName.Language)
        extraData.set("", forKey: DataName.AccessToken)
    }
    
    // MARK: Downloading needed data
    static func updateLocalData() {
        /*  Getting ShipID, Achievements, Commander Skills, Collections,
            Upgrades, Flags, Camouflage, ExpectedValue
            Parse them and save as json files  */
        
    }
    
}

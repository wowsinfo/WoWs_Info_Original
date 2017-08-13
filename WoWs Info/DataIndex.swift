//
//  DataIndex.swift
//  WoWs Info
//
//  Created by Yiheng Quan on 13/8/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class DataIndex: NSObject {
    
    // Five known servers
    enum ServerIndex: Int {
        case Russia = 0, Europe, NorthAmercia, Asia, China
    }
    
    // For all saved data name
    enum DataName: String {
        // Old data names
        case FirstLaunch = "first_launch"
        case SearchLimit = "search_limit"
        case Server = "server"
        case UserName = "username"
        case IsThereAds = "ads"
        case IsAdvancedUnlocked = "advancedunlocked"
        case hasPurchased = "hasPurchased"
        case friend = "friend_list"
        case tk = "team_killer"
        case theme = "theme"
        case APILanguage = "api_language"
        case NewsLanague = "news_language"
        case didReview = "review"
        case didShare = "share"
        case gotoGithub = "github"
        case pointSystem = "point_system"
        // Some new names
        
    }
    
    
    
    
}

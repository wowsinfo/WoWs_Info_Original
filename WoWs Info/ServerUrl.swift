//
//  ServerUrl.swift
//  WoWs Info
//
//  Created by Henry Quan on 15/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ServerUrl {
    
    static let Server = ["ru", "eu", "com", "asia"]
    static let TodayDomain = ["ru", "eu", "na", "asia"]
    static let NumberDomain = ["ru.", "", "na.", "asia."]
    static let ServerName = ["Russia", "Europe", "North America", "Asia"]
    
    var index: Int
    var server = ""
    
    init(serverIndex: Int) {
        
        index = serverIndex
        server = ServerUrl.Server[serverIndex]
        
    }
    
    
    func getServerDomain() -> String{
        
        return server
        
    }
    
    func getUrlForToday(account: String, name: String) -> String {
        
        return "https://\(ServerUrl.TodayDomain[index]).warships.today/player/\(account)/\(name)"
        
    }
    
    func getUrlForNumber(account: String, name: String) -> String {
        
        return "http://\(ServerUrl.NumberDomain[index])wows-numbers.com/player/\(account),\(name)/"
        
    }
    
}


//
//  PlayerAccountID.swift
//  WoWs Info
//
//  Created by Henry Quan on 16/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

// Save Account ID forever until player changes
class PlayerAccountID {
    
    static var AccountID = ""
    init(ID: String) {
        PlayerAccountID.AccountID = ID
    }
    
}

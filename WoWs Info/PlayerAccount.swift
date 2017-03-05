//
//  PlayerAccountID.swift
//  WoWs Info
//
//  Created by Henry Quan on 16/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

// Save Account ID forever until player changes
class PlayerAccount {
    
    static var AccountID = ""
    static var AccountName = ""
    init(ID: String, Name: String) {
        PlayerAccount.AccountID = ID
        PlayerAccount.AccountName = Name
    }
    
}

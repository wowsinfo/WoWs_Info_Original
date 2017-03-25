//
//  WoWsInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 14/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class WoWsInfoController: UIViewController {

    let infoIcon = [#imageLiteral(resourceName: "Battles"),#imageLiteral(resourceName: "WinRate"),#imageLiteral(resourceName: "EXP"),#imageLiteral(resourceName: "Damage"),#imageLiteral(resourceName: "KillDeathRatio"),#imageLiteral(resourceName: "HitRatio"),#imageLiteral(resourceName: "RankImage")]
    let otherIcon = [#imageLiteral(resourceName: "Dashboard"),#imageLiteral(resourceName: "Screenshot"),#imageLiteral(resourceName: "Number"),#imageLiteral(resourceName: "Star"),#imageLiteral(resourceName: "Web")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "WoWs Info"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

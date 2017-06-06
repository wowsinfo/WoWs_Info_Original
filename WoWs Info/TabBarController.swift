//
//  TabBarController.swift
//  WoWs Info
//
//  Created by Henry Quan on 27/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Search
        self.selectedIndex = 2
        // ThemeColour
        self.tabBar.tintColor = UserDefaults.standard.color(forKey: DataManagement.DataName.theme)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

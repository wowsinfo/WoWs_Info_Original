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
        
        // Localize News, Wiki and Dashboard
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if self.selectedIndex == 3 {
            // Dashboard is only for paid user
            if UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked) == false {
                // Ask user to pruchase pro version
                
            }
        }
    }
}

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == NSLocalizedString("DASHBOARD_BAR", comment: "Dashboard Name") {
            // Dashboard is only for paid user
            if UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked) == false {
                // Ask user to pruchase pro version
                let proOnly = UIAlertController(title: "Sorry", message: "This is for pro version only. Update to Pro version to use this feature.", preferredStyle: .alert)
                proOnly.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(proOnly, animated: true, completion: {
                    self.selectedIndex = 2
                })
            }
        } else {
            print(self.selectedIndex)
        }
    }
}

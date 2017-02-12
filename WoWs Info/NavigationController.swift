//
//  NavigationController.swift
//  WoWs Info
//
//  Created by Henry Quan on 4/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class NavigationController : UINavigationController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = UIColor(red: CGFloat(85)/255, green: CGFloat(163)/255, blue: CGFloat(255)/255, alpha: 1.0)
        appearance.tintColor = UIColor.white
        appearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}

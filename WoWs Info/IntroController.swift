//
//  IntroController.swift
//  WoWs Info
//
//  Created by Yiheng Quan on 13/8/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class IntroController: UIViewController {

    @IBOutlet weak var themeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup theme for intro
        let theme = UIColor.getCurrTheme()
        view.backgroundColor = theme
        themeImage.backgroundColor = theme
        if UserDefaults.isPro() {
            // Change this to a Pro Image
            themeImage.image = #imageLiteral(resourceName: "ThemePro")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

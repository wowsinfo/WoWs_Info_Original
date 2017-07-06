//
//  AboutController.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet weak var themeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup theme
        themeImage.backgroundColor = Theme.getCurrTheme()
        themeImage.layer.cornerRadius = themeImage.frame.width / 5
        themeImage.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func gotoTwitter(_ sender: UITapGestureRecognizer) {
        // Source code
        UIApplication.shared.openURL(URL(string: "https://github.com/HenryQuan/WoWs_Info_IOS")!)
    }
}

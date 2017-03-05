//
//  AboutController.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoTwitter(_ sender: UITapGestureRecognizer) {
        // Go to my twitter account
        UIApplication.shared.openURL(URL(string: "https://twitter.com/Yiheng_Quan")!)
    }
}

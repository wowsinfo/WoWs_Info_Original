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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func gotoTwitter(_ sender: UITapGestureRecognizer) {
        // Source code
        UIApplication.shared.openURL(URL(string: "https://github.com/HenryQuan/WoWs_Info_IOS")!)
    }
}

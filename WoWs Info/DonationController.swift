//
//  DonationController.swift
//  WoWs Info
//
//  Created by Henry Quan on 23/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class DonationController: UIViewController {

    @IBOutlet weak var donationBtn: UIButton!
    let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isProVersion {
            donationBtn.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

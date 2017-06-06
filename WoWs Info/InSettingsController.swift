//
//  SettingsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 30/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import MessageUI
import Kanna

class InSettingsController : UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var silderCountLabel: UILabel!
    @IBOutlet weak var limitSlider: UISlider!
    @IBOutlet weak var updateBtn: UIButton!
 
    let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let limit = UserDefaults.standard.integer(forKey: DataManagement.DataName.SearchLimit)
        silderCountLabel.text = "\(limit)"
        limitSlider.setValue(Float(limit), animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        UserDefaults.standard.set(Int(limitSlider.value), forKey: DataManagement.DataName.SearchLimit)
        
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        let value = Int(limitSlider.value)
        silderCountLabel.text = "\(value)"
        
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        if DataUpdater.update() {
            let success = UIAlertController.QuickMessage(title: "Success", message: "ExpectedValue.json is up to date", cancel: "OK")
            self.present(success, animated: true, completion: nil)
            updateBtn.isEnabled = false
        } else {
            let fail = UIAlertController.QuickMessage(title: "Error", message: "Fail to update ExpectedValue.json", cancel: "OK")
            self.present(fail, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = "BACK".localised()
        navigationItem.backBarButtonItem = backItem
        
    }
    
}

//
//  SettingsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 30/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import MessageUI

class InSettingsController : UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var silderCountLabel: UILabel!
    @IBOutlet weak var limitSlider: UISlider!
 
    let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let limit = UserDefaults.standard.integer(forKey: DataManagement.DataName.SearchLimit)
        silderCountLabel.text = "\(limit)"
        limitSlider.setValue(Float(limit), animated: true)
        
        let name = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)
        username.text = name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        UserDefaults.standard.set(Int(limitSlider.value), forKey: DataManagement.DataName.SearchLimit)
        
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        let name = username.text
        let validName = name?.replacingOccurrences(of: " ", with: "")
        
        if validName != "" {
            UserDefaults.standard.set(validName, forKey: DataManagement.DataName.UserName)
        }

        username.resignFirstResponder()
        
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        let value = Int(limitSlider.value)
        silderCountLabel.text = "\(value)"
        
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem
        
    }
    
}

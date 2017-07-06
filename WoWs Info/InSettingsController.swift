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
        
        self.tableView.delegate = self
        
        // Setup Theme
        limitSlider.tintColor = Theme.getCurrTheme()
        updateBtn.backgroundColor = Theme.getCurrTheme()
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
    
    // MARK: Button pressed
    @IBAction func updateBtnPressed(_ sender: Any) {
        if DataUpdater.update() {
            let success = UIAlertController.QuickMessage(title: "UPDATE_SUCCESS".localised(), message: "UPDATE_SUCCESS_MESSAGE".localised(), cancel: "OK")
            self.present(success, animated: true, completion: nil)
            updateBtn.isEnabled = false
        } else {
            let fail = UIAlertController.QuickMessage(title: "UPDATE_FAIL".localised(), message: "UPDATE_FAIL_MESSAGE".localised(), cancel: "OK")
            self.present(fail, animated: true, completion: nil)
        }
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let tag = cell.tag
            if tag >= 100 && tag <= 101 {
                print("Language Selection")
                // Choose Language
                let language = UIAlertController(title: "LANGUAGE_MESSAGE".localised(), message: "", preferredStyle: .alert)
                if tag == 100 {
                    language.message = "API"
                } else {
                    language.message = "NEWS".localised()
                }
                
                language.addAction(UIAlertAction(title: "LANGUAGE_AUTO".localised(), style: .default, handler: { (_) in
                    self.setLanguage(tag: tag, index: Language.Index.auto)
                }))
                language.addAction(UIAlertAction(title: "简体中文", style: .default, handler: { (_) in
                    self.setLanguage(tag: tag, index: Language.Index.sChinese)
                }))
                language.addAction(UIAlertAction(title: "繁體中文".localised(), style: .default, handler: { (_) in
                    self.setLanguage(tag: tag, index: Language.Index.tChinese)
                }))
                language.addAction(UIAlertAction(title: "English".localised(), style: .default, handler: { (_) in
                    self.setLanguage(tag: tag, index: Language.Index.English)
                }))
                language.addAction(UIAlertAction(title: "SHARE_CANCEL".localised(), style: .cancel, handler: nil))
                self.present(language, animated: true, completion: nil)
            }
            if tag == 99 {
                // Clean Cache
                CacheCleaner.cleanCache()
            }
            
        }
    }
    
    func setLanguage(tag: Int, index: Int) {
        if tag == 100 {
            UserDefaults.standard.set(index, forKey: DataManagement.DataName.APILanguage)
        } else if tag == 101 {
            UserDefaults.standard.set(index, forKey: DataManagement.DataName.NewsLanague)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = "BACK".localised()
        navigationItem.backBarButtonItem = backItem
        
    }
    
}

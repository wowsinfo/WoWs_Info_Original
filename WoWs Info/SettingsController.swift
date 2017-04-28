//
//  SettingsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 28/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let imageSet = [#imageLiteral(resourceName: "Web"),#imageLiteral(resourceName: "AppStore"),#imageLiteral(resourceName: "Donation"),#imageLiteral(resourceName: "Settings")]
    let wordSet = [NSLocalizedString("WEB_SETTINGS", comment: "Word for Web"), NSLocalizedString("APP_SETTINGS", comment: "Word for appstore"), NSLocalizedString("DONATION_SETTINGS", comment: "Word for donation"), NSLocalizedString("SETTINGS_SETTINGS", comment: "Word for settings")]
    let segueSet = ["gotoProVersion", "gotoWeb", "gotoReview", "gotoDonate", "gotoSettings"]
    var isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tableview
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorColor = UIColor.clear
        
        settingsTableView.estimatedRowHeight = 60
        settingsTableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("SETTINGS_SETTINGS", comment: "Settings Title")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If it is Pro
        isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPro { return imageSet.count }
        // IF not ask user to buy it
        return imageSet.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if isPro {
            // Paid version
            let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            cell.logoImage.image = imageSet[index]
            cell.nameLabel.text = wordSet[index]
            return cell
        } else {
            // Free version
            if index == 0 {
                let cell = settingsTableView.dequeueReusableCell(withIdentifier: "UpgradeCell", for: indexPath) as! UpgradeCell
                cell.proLabel.text = NSLocalizedString("UPGRADE_SETTINGS", comment: "Upgrade to Pro")
                return cell
            } else {
                let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.logoImage.image = imageSet[index - 1]
                cell.nameLabel.text = wordSet[index - 1]
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isPro {
            performSegue(withIdentifier: segueSet[indexPath.row + 1], sender: nil)
        } else {
            print(indexPath.row)
            performSegue(withIdentifier: segueSet[indexPath.row], sender: nil)
        }
    }
    
    // MARK: Button pressed
    @IBAction func shareBtnPressed(_ sender: Any) {
        let share = UIActivityViewController.init(activityItems: [URL(string: "https://itunes.apple.com/app/id1202750166")!], applicationActivities: nil)
        self.present(share, animated: true, completion: nil)
    }

}
